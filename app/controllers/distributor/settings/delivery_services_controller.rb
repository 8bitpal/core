class Distributor::Settings::DeliveryServicesController < Distributor::BaseController
  def show
    render_form
  end

  def create
    delivery_service_params = params[:delivery_service]
    delivery_service_params.delete(:delete) # XXX

    delivery_service = DeliveryService.new(delivery_service_params)
    delivery_service.distributor = current_distributor

    if delivery_service.save
      flash.now[:notice] = "Your new delivery service has been created."
    else
      flash.now[:error] = delivery_service.errors.full_messages.to_sentence
    end

    render_form
  end

  def update
    return destroy if params[:delivery_service][:delete].to_s.to_bn # XXX temporary ugly pseudo REST

    delivery_service_params = params[:delivery_service]
    delivery_service_params.delete(:delete) # XXX see above
    delivery_service = current_distributor.delivery_services.find(delivery_service_params.delete(:id))

    if delivery_service.update_attributes(delivery_service_params)
      flash.now[:notice] = "Your delivery service has been updated."
    else
      flash.now[:error] = delivery_service.errors.full_messages.to_sentence
    end

    render_form
  end

  def destroy
    delivery_service_params = params[:delivery_service]
    delivery_service = current_distributor.delivery_services.find(delivery_service_params.delete(:id))

    if delivery_service.destroy
      flash.now[:notice] = "Your delivery service has been deleted."
    else
      flash.now[:error] = delivery_service.errors.full_messages.to_sentence
    end

    render_form
  end

private

  def render_form
    delivery_services = current_distributor.delivery_services.decorate
    delivery_services.unshift(new_delivery_service) # new delivery service

    render 'distributor/settings/delivery_services', locals: {
      delivery_services: delivery_services,
    }
  end

  def new_delivery_service
    DeliveryService.new(distributor: current_distributor).decorate
  end

  def delivery_service_params
    params.require(:delivery_service).permit(
      :name, :fee, :instructions, :pickup_point, :delete,
      :schedule_rule_attributes => [:mon, :tue, :wed, :thu, :fri, :sat, :sun]
    )
  end
end
