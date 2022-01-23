class Distributor::SessionsController < Devise::SessionsController
  def new
    analytical.event('view_distributor_sign_in')
    super
  end

  def create
    analytical.event('distributor_signed_in')

    result = super

    DistributorLogin.track(current_distributor) unless current_admin.present?

    result
  end

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:username, :email, :password, :password_confirmation, :remember_me)
    end
  end

end
