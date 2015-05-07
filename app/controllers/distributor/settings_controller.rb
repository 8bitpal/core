class Distributor::SettingsController < Distributor::BaseController
  respond_to :html, :json

  before_action :catch_cancel

  def organisation
    time = Time.new
    @default_delivery_time  = Time.new(time.year, time.month, time.day, current_distributor.advance_hour)
    @default_delivery_days  = current_distributor.advance_days
    @default_automatic_time = Time.new(time.year, time.month, time.day, Distributor::AUTOMATIC_DELIVERY_HOUR)
  end

  def webstore(form = SettingsWebstoreForm.for_distributor(current_distributor))
    @form = form
    render :webstore
  end

  def save_webstore
    form = SettingsWebstoreForm.new(params[:settings_webstore_form])
    message = save_webstore_message(form)

    if form.save(current_distributor)
      redirect_to distributor_settings_webstore_path, notice: message
    else
      flash.now[:alert] = "Web Store settings could not be saved, please check the errors displayed."
      webstore(form)
    end
  end

  def spend_limit_confirmation
    spend_limit = BigDecimal.new(params[:spend_limit]) * BigDecimal.new(100)
    update_existing = params[:update_existing].to_bool
    send_halt_email = params[:send_halt_email].to_bool
    count = current_distributor.number_of_customers_halted_after_update(spend_limit, update_existing)
    if count > 0
      count_emailed = current_distributor.number_of_customers_emailed_after_update(spend_limit, update_existing)
      render text: "Updating the minimum balance will halt #{count} customers deliveries. #{count_emailed.to_s + ' customers with pending orders will be emailed that their account has been halted until payment is made. ' if count_emailed > 0 && send_halt_email && current_distributor.send_email? }Are you sure?"
    else
      render text: "safe"
    end
  end

  def catch_cancel
    redirect_to :back if params[:commit] == 'cancel'
  end

private

  def save_webstore_message(form)
    newly_activated_webstore = !current_distributor.active_webstore && form.webstore_enabled.to_bool

    if newly_activated_webstore
      "Your #{view_context.link_to('Web Store', current_distributor.webstore_url, target: '_blank')} is now active.".html_safe
    else
      "Web Store settings were successfully saved."
    end
  end
end
