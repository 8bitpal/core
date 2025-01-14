class Distributor::DistributorsController < Distributor::ResourceController
  actions :update

  respond_to :html, :json

  def update
    update! do |success, failure|
      success.html { redirect_to distributor_settings_organisation_path, notice: 'Organisation was successfully updated.' }
      failure.html { render 'distributor/settings/organisation' }
    end
  end

protected

  def resource
    current_distributor
  end

  def begin_of_association_chain
    nil
  end

private
  def distributor_params
    params.require(:distributor).permit(:email, :password)
  end

end
