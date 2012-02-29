require "spec_helper"

describe CustomerMailer do
  before { @customer = Fabricate(:customer) }

  describe "login_details" do
    let(:mail) { CustomerMailer.login_details(@customer)}

    it "renders the headers" do
      mail.subject.should =~ /Login details/
      mail.to.should eq([@customer.email])
      mail.from.should eq([@customer.distributor.support_email])
    end
  end

  describe "invoice" do
    before(:each) do
      @invoice = Fabricate(:invoice)
    end
    let(:mail) { CustomerMailer.invoice(@invoice) }

    it "renders the headers" do
      mail.to.should eq([@invoice.account.customer.email])
      mail.from.should eq([@invoice.account.distributor.support_email])
    end

    it "renders the body" do
      mail.body.encoded.should match(@invoice.account.customer.name)
    end
  end

end
