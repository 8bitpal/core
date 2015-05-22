class Jobs
  # XXX: keep this method short for obvious reasons...
  def self.run_five_minutely
    # NOOP at the moment
  end

  def self.run_hourly
    CronLog.log("Checking distributors for automatic daily list creation.")
    Distributor.create_daily_lists

    CronLog.log("Checking deliveries and packages for automatic completion.")
    Distributor.automate_completed_status

    CronLog.log("Checking orders, deactivating those without any more deliveries.")
    Order.deactivate_finished

    CronLog.log("Checking distributors if next order cache needs updating.")
    Distributor.update_next_occurrence_caches

    CronLog.log("Running metrics for Munin graphs.")
    Metrics.calculate_and_store_for_munin

    CronLog.log("Running metrics for Librato.")
    Metrics.calculate_and_push_to_librato

    Distributor.refresh_webstore_caches
  end

  def self.run_daily
    CronLog.where("created_at < ?", 1.year.ago).delete_all

    metrics_count = Metrics.calculate_and_store
    CronLog.log("#{metrics_count} metrics calculated and stored.")

    DataIntegrity.delay(
      # - servers are using NZ time
      # - 2pm to 3pm is the calmest window for us (little visits) --> +14
      # - houly jobs run at minute 0 and we don't want to run integrity tests at the same time in
      #   order to spread resource usage -> +.5
      run_at: DateTime.tomorrow + 14.5.hours,
      queue: "#{__FILE__}:#{__LINE__}",
    ).check_and_email
  end
end
