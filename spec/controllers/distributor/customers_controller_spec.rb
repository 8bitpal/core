require 'spec_helper'

describe Distributor::CustomersController do
  render_views

  as_distributor
  context :with_customer do
    before { @customer = Fabricate(:customer, distributor: @distributor) }

    context "send_login_details" do
      before do
        @send_login_details = lambda { get :send_login_details, id: @customer.id }
        @send_login_details.call
      end

      it "should send an email" do
        expect {
          @send_login_details.call
        }.to change{ActionMailer::Base.deliveries.size}.by(1)
      end

      it "should reset password" do
        assigns(:customer).password.should_not == @customer.password
      end

      it "should redirect correctly" do
        response.should redirect_to(distributor_customer_path(@customer))
      end
    end
    
    context "#update" do
      before do
        @customer_2 = Fabricate(:customer, distributor: @distributor, email: "duplicate@dups.com")
      end

      it 'should show the errors' do
        put :update, id: @customer.id, customer: {email: "duplicate@dups.com"}
        assigns(:form_type).should eq('personal_form')
      end
    end

    describe "#show" do
      before do
        Fabricate(:order, account: @customer.account(true))
        @customer.reload
      end

      it "should show the customer and their orders" do
        get :show, id: @customer.id
      end
    end
  end

  
  context "performance" do
    before do
      3.times do
        c = Fabricate(:customer, distributor: @distributor)
        Fabricate(:order, account: c.account)
      end
    end

    xit "should not take long to load customer index" do
      expect {
        get :index
      }.to take_less_than(0.3).seconds
      # FIXME Specs should NOT be machine-dependent since the hardware on CI may
      # be different than production
    end
  end

end
