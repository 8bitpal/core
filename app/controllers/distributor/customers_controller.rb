class Distributor::CustomersController < Distributor::ResourceController
  respond_to :html, :xml, :json

  before_filter :check_setup, only: [:index]
  before_filter :get_form_type, only: [:edit, :update]
  before_filter :get_email_templates, only: [:index, :show]

  def index
    index! do
      @show_tour = current_distributor.customers_index_intro

      amount = @customers.map(&:account).map(&:balance).sum
      @customers_total_balance = CrazyMoney.new(amount).with_currency(current_distributor.currency)
    end
  end

  def new
    new! do
      @address = @customer.build_address
    end
  end

  def create
    create! do |success, failure|
      success.html do
        tracking.event(current_distributor, "new_customer") unless current_admin.present?
        redirect_to distributor_customer_url(@customer)
      end
    end
  end

  def edit
    edit!
  end

  def update
    update! do |success, failure|
      success.html { redirect_to distributor_customer_url(@customer) }
      failure.html do
        if (phone_errors = @customer.address.errors.get(:phone_number))
          # Highlight all missing phone fields
          phone_errors.each do |error|
            PhoneCollection.attributes.each do |type|
              @customer.address.errors[type] << error
            end
          end
        end

        render get_form_type
      end
    end
  end

  def show
    show! do
      @address          = @customer.address
      @account          = @customer.account.decorate
      @orders           = @account.orders.active.decorate
      @deliveries       = @account.deliveries.ordered
      @transactions     = account_transactions(@account)
      @show_more_link   = (@transactions.size != @account.transactions.count)
      @transactions_sum = @account.calculate_balance
      @show_tour        = current_distributor.customers_show_intro
    end
  end

  def send_login_details
    @customer = Customer.find(params[:id])

    @customer.randomize_password
    @customer.save

    CustomerMailer.raise_errors do
      if !@customer.send_email?
        flash[:error] = "Sending emails is disabled, login details not sent"
      elsif @customer.send_login_details
        flash[:notice] = "Login details successfully sent"
      else
        flash[:error] = "Login details failed to send"
      end
    end

    tracking.event(current_distributor, "sent_login_details") unless current_admin.present?

    redirect_to distributor_customer_url(@customer)
  end

  def email
    link_action = params[:link_action]
    link_action = "send" if link_action.empty?

    message = if (link_action == "delete")
      email_templates_update(link_action)

    else
      return error("Oops") unless params[:email_template]

      email_template = EmailTemplate.new(
        params[:email_template][:subject],
        params[:email_template][:body]
      )

      if !email_template.valid?
        return error(email_template.errors.join('<br>'))
      end

      email_templates_update(link_action, email_template)
    end

    if message && current_distributor.save
      flash[:notice] = message if link_action == "send"
      render json: { link_action => true, message: message }
    else
      return error(current_distributor.errors.full_messages)
    end
  end

  def export
    recipient_ids = params[:export][:recipient_ids].split(',').map(&:to_i)
    csv_string    = CustomerCSV.generate(current_distributor, recipient_ids)

    tracking.event(current_distributor, "export_csv_customer_list") unless current_admin.present?

    send_csv("customer_export", csv_string)
  end

  def impersonate
    redirect_to distributor_root_path and return unless current_admin.present?

    customer = current_distributor.customers.find(params[:id])
    sign_in(customer, bypass: true) # bypass means it won't update last logged in stats

    redirect_to customer_root_path
  end

  def activity
    customer = current_distributor.customers.find(params[:id])

    render partial: "activity", locals: { activities: customer.recent_activities }
  end

protected

  def get_form_type
    @form_type = (params[:form_type].to_s == 'delivery' ? 'delivery_form' : 'personal_form')
  end

  def collection
    @customers = end_of_association_chain

    if params[:query].present?
      query = params[:query].gsub(/\./, '')
      if params[:query].to_i == 0
        @customers = current_distributor.customers.search(query)
      else
        @customers = current_distributor.customers.where(number: query.to_i)
      end

      tracking.event(current_distributor, "search_customer_list") unless current_admin.present?
    end

    if (tag = params[:tag]).present?
      @customers = @customers.tagged_with(tag) unless tag.in?(CustomerDecorator.all_dynamic_tags_as_a_list)
    end

    @customers = @customers.ordered_by_next_delivery.includes(
      account: {delivery_service: {}}, tags: {}, next_order: {box: {}}
    ).decorate

    if tag.in?(CustomerDecorator.all_dynamic_tags_as_a_list)
      @customers = @customers.select { |customer| tag.in?(customer.dynamic_tags) }
    end
  end

private

  def error message
    render json: { message: message }, status: :unprocessable_entity
  end

  def email_templates_update action, email_template = nil
    selected_email_template_id = params[:selected_email_template_id].to_i
    recipient_ids = params[:recipient_ids].split(',').map(&:to_i)
    message = nil

    case action
    when "update"
      current_distributor.email_templates[selected_email_template_id] = email_template
      message = "Your changes have been saved."

    when "delete"
      deleted = current_distributor.email_templates.delete_at(selected_email_template_id)
      message = "Email template <em>#{deleted.subject}</em> has been deleted."

    when "save"
      current_distributor.email_templates << email_template
      message = "Your new email template <em>#{email_template.subject}</em> has been saved."

    when "preview"
      customer = Customer.find recipient_ids.first
      personalized_email = email_template.personalize(customer)
      CustomerMailer.email_template(current_distributor, personalized_email).deliver
      message = "A preview email has been sent to #{current_distributor.email}."

    when "send"
      if params[:commit]
        message = send_email recipient_ids, email_template

        tracking.event(current_distributor, "sent_group_email") unless current_admin.present?
      end
    end

    message
  end

  def send_email recipient_ids, email
    recipient_ids.each do |id|
      customer = Customer.find id
      personalized_email = email.personalize(customer)

      CustomerMailer.delay(
        priority: Figaro.env.delayed_job_priority_high,
        queue: "#{__FILE__}:#{__LINE__}",
      ).email_template(customer, personalized_email)
    end

    message = "Your email \"#{email.subject}\" is being sent to "
    message << if recipient_ids.size == 1
      Customer.find(recipient_ids.first).name
    else
      "#{recipient_ids.size} customers"
    end
    message << "..."
  end
end
