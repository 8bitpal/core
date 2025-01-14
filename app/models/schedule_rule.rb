class ScheduleRule < ActiveRecord::Base
  DAYS = [:sun, :mon, :tue, :wed, :thu, :fri, :sat].freeze # Order of this is important, it matches sunday: 0, monday: 1 as is standard
  RECUR = [:single, :weekly, :fortnightly, :monthly].freeze

  belongs_to :scheduleable, polymorphic: true, inverse_of: :schedule_rule
  belongs_to :schedule_pause, dependent: :destroy

  scope :with_next_occurrence, (lambda do |date, ignore_pauses, ignore_halts|
    select("schedule_rules.*, next_occurrence('#{date.to_s(:db)}', #{ignore_pauses}, #{ignore_halts}, schedule_rules.*) as next_occurrence")
  end)

  after_save :notify_associations
  after_save :record_schedule_transaction, if: :changed?

  validate :includes_dow_if_not_one_off
  delegate :local_time_zone, to: :scheduleable, allow_nil: true
  delegate :recurs?, to: :frequency

  def self.one_off(datetime)
    ScheduleRule.new(start: datetime)
  end

  def self.recur_on(start, days, recur, week = 0)
    days &= DAYS # whitelist
    days = days.inject({}) { |h, i| h.merge(i => true) } # Turn array into hash
    days = DAYS.inject({}) { |h, i| h.merge(i => false) }.merge(days) # Fill out the rest with false

    valid_recur = RECUR
    raise "recur '#{recur}' is not part of #{valid_recur}" unless recur.in? valid_recur

    params = days.merge(recur: recur, week: week)
    params.merge!(start: start) if start

    ScheduleRule.new(params)
  end

  def self.weekly(start = nil, days = [])
    recur_on(start, days, :weekly)
  end

  def self.fortnightly(start, days)
    recur_on(start, days, :fortnightly)
  end

  def self.monthly(start, days)
    recur_on(start, days, :monthly)
  end

  def self.number_of_days
    @number_of_days ||= DAYS.size
  end

  def self.day(number)
    DAYS[number % number_of_days]
  end

  def recur
    r = self[:recur]
    r.nil? ? :one_off : r.to_sym
  end

  def occurs_on?(datetime)
    case recur
    when :one_off
      start == datetime
    when :single
      start == datetime
    when :weekly
      weekly_occurs_on?(datetime)
    when :fortnightly
      fortnightly_occurs_on?(datetime)
    when :monthly
      monthly_occurs_on?(datetime)
    end
  end

  def weekly_occurs_on?(datetime)
    day = datetime.strftime("%a").downcase.to_sym
    self.send("#{day}?") && start <= datetime
  end

  def fortnightly_occurs_on?(datetime)
    # So, theory is, the difference between the start and the date in question as days, divided by 7 should give the number of weeks since the start.  If the number is even, we are on a fortnightly.
    first_occurence = start - start.wday
    weekly_occurs_on?(datetime) && ((datetime - first_occurence) / 7).to_i.even? # 7 days in a week
  end

  def monthly_occurs_on?(datetime)
    weekly_occurs_on?(datetime) && ((datetime.day - 1) / 7).to_i == week
  end

  def next_occurrence(date = nil, opts = {})
    opts = { ignore_pauses: false,
             ignore_halts: false }.merge(opts)

    date ||= Date.current

    unless new_record?
      occurrence = ScheduleRule.where(id: self.id)
      occurrence = occurrence.with_next_occurrence(date, opts[:ignore_pauses], opts[:ignore_halts])
      occurrence = occurrence.first.attributes["next_occurrence"]

      occurrence.is_a?(String) ? Date.parse(occurrence) : occurrence
    end
  end

  def next_occurrences(num, start, opts = {})
    opts = { ignore_pauses: false,
             ignore_halts: false }.merge(opts)
    result = []
    current = start.to_date

    0.upto(num - 1).each do
      current = next_occurrence(current, { ignore_pauses: opts[:ignore_pauses],
                                           ignore_halts: opts[:ignore_halts] })

      if current.present?
        result << current
        current += 1.day # otherwise it will get stuck in a loop
      else
        return result
      end
    end
    result
  end
  alias_method :occurrences, :next_occurrences

  def occurrences_between(start, finish, opts = {})
    raise ArgumentError unless start.is_a?(Date) && finish.is_a?(Date)

    opts = { max: 200, ignore_pauses: false, ignore_halts: false }.merge(opts)
    start, finish = [start, finish].reverse if start > finish

    result = []
    current = start
    0.upto(opts[:max]).each do
      current = next_occurrence(current, { ignore_pauses: opts[:ignore_pauses],
                                           ignore_halts: opts[:ignore_pauses] })

      if current.present? && current <= finish
        result << current
        current += 1.day # otherwise it will get stuck in a loop
      else
        return result
      end
    end
    result
  end

  def frequency
    Bucky::Frequency.new(recur)
  end

  def on_day?(day)
    raise "#{day} is not a valid day" unless DAYS.include?(day)
    if one_off?
      day == DAYS[start.wday]
    else
      self.send(day)
    end
  end

  def one_off?; recur == :one_off || recur == :single || recur.nil?; end

  def single?; recur == :single; end

  def weekly?; recur == :weekly; end

  def fortnightly?; recur == :fortnightly; end

  def monthly?; recur == :monthly; end

  def days
    DAYS.select { |day| on_day?(day) }
  end

  def days_as_indexes
    DAYS.map.each_with_index { |day, index| index if on_day?(day) }.compact
  end

  def delivery_days
    I18n.t('date.day_names').select.each_with_index do |_day, index|
      runs_on index
    end.to_sentence
  end

  def runs_on(number)
    on_day?(DAYS[number % DAYS.size])
  end

  # returns true if the given schedule_rule occurs on a subset of this schedule_rule's occurrences
  def includes?(schedule_rule, opts = {})
    opts = { ignore_start: false }.merge(opts)

    unless schedule_rule.is_a?(ScheduleRule)
      raise ArgumentError, "Expecting a ScheduleRule, not #{schedule_rule.class}"
    end

    case recur
    when :one_off, :single
      return false unless schedule_rule.one_off?
    when :fortnightly
      return false if schedule_rule.weekly? || schedule_rule.monthly?
      if schedule_rule.fortnightly?
        return false unless ((schedule_rule.start - (start - start.wday)) / 7).to_i.even?
      end
    when :monthly
      return false unless schedule_rule.monthly? || (schedule_rule.one_off? && schedule_rule.start.day < 8)
    end

    too_soon = (local_time_zone.present? ? start.to_datetime.in_time_zone(local_time_zone) : start) > schedule_rule.start
    return false if !opts[:ignore_start] && too_soon

    if schedule_pause
      return false unless ((schedule_rule.one_off? &&
                            schedule_rule.start < schedule_pause.start) ||
        schedule_pause.finish <= schedule_rule.start) ||
                          schedule_pause.finish <= schedule_rule.start
    end

    schedule_rule.days.all? { |day| on_day?(day) }
  end

  def has_at_least_one_day?
    DAYS.map { |day| self.send(day) }.any?
  end

  def json
    to_json(include: :schedule_pause)
  end

  def notify_associations
    scheduleable.schedule_changed(self) if changed? && scheduleable.present?
  end

  def record_schedule_transaction
    ScheduleTransaction.create!(schedule_rule: json, schedule_rule_id: self.id)
  end

  def deleted_days
    DAYS.select { |day| self.send("#{day}_changed?".to_sym) && self.send(day) == false }
  end

  def deleted_day_numbers
    DAYS.each_with_index.map { |day, index| self.send("#{day}_changed?".to_sym) && self.send(day) == false ? index : nil }.compact
  end

  def pause!(start, finish = nil)
    pause(start, finish)
    save!
  end

  def pause(start, finish = nil)
    start = Date.parse(start.to_s) unless start.is_a?(Date)
    finish = Date.parse(finish.to_s) unless finish.blank? || finish.is_a?(Date)
    start, finish = finish, start if finish && start > finish

    self.schedule_pause = SchedulePause.create!(start: start, finish: finish)
  end

  def pause_date
    result = !pause_expired? && schedule_pause.start
    result ? result : nil
  end

  def resume_date
    result = !pause_expired? && schedule_pause.finish
    result ? result : nil
  end

  def pause_expired?(date = Date.current)
    schedule_pause.nil? || (!schedule_pause.finish.nil? && schedule_pause.finish < date)
  end

  def remove_pause
    self.schedule_pause = nil
  end

  def remove_pause!
    remove_pause
    save!
  end

  def remove_day(day)
    self.send("#{to_day(day)}=", false)
  end

  def remove_day!(day)
    remove_day(day)
    save!
  end

  def to_day(something)
    translate = {
      sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6,
      sun: 0, mon: 1, tue: 2, wed: 3, thu: 4, fri: 5, sat: 6
    }

    if something.is_a?(Symbol)
      raise "#{something} is not understood as a day of the week" unless translate.include?(something)
      return DAYS[translate[something]]
    elsif something.is_a?(Fixnum) && (0..6).cover?(something)
      return DAYS[something]
    else
      raise "Couldn't turn #{something} into a day, sorry! ;)"
    end
  end

  def to_s
    ActiveSupport::Deprecation.warn("ScheduleRule#to_s is deprecated")

    deliver_on
  end

  def deliver_on
    case recur
    when :one_off
      "#{I18n.t('models.schedule_rule.deliver_on')} #{start.to_s(:flux_cap)}"
    when :single
      "#{I18n.t('models.schedule_rule.deliver_on')} #{start.to_s(:flux_cap)}"
    when :weekly
      "#{I18n.t('models.schedule_rule.deliver_weekly_on')} #{delivery_days}"
    when :fortnightly
      "#{I18n.t('models.schedule_rule.deliver_fornightly_on')} #{delivery_days}"
    when :monthly
      "#{I18n.t('models.schedule_rule.deliver_monthly_on')} #{week.succ.ordinalize_in_full} #{delivery_days}"
    end
  end

  def halt!
    self.halted = true
    save!
  end

  def unhalt!
    self.halted = false
    save!
  end

  def paused?
    schedule_pause.present?
  end

  def no_occurrences?
    next_occurrence.nil?
  end

private

  def includes_dow_if_not_one_off
    errors.add(:base, "Must include at least one day of the week") if !one_off? && days.blank?
  end
end
