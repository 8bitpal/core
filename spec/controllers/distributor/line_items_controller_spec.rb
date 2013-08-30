require 'spec_helper'

describe Distributor::LineItemsController do
  render_views

  sign_in_as_distributor

  describe '#create' do
    context 'with valid params' do
      before do
        post :create, { stock_list: { names: "Apples\nOranges\nGrapes" } }
      end

      specify { flash[:notice].should eq('The customer preferences were successfully updated.') }
      specify { response.should redirect_to(distributor_settings_customer_preferences_url) }
    end

    context 'with invalid params' do
      before do
        post :create, { stock_list: { names: "" } }
      end

      specify { flash[:error].should eq('Could not update the customer preferences.') }
      specify { response.should redirect_to(distributor_settings_customer_preferences_url(edit: true)) }
    end
  end
end
