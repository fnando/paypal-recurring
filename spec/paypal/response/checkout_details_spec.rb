require "spec_helper"

describe PayPal::Recurring::Response::Details do
  context "when successful" do
    use_vcr_cassette "details/success"

    subject {
      ppr = PayPal::Recurring.new(:token => "EC-08C2125544495393T")
      ppr.checkout_details
    }

    it { should be_valid }
    it { should be_success }

    its(:errors) { should be_empty }
    its(:status) { should == "PaymentActionNotInitiated" }
    its(:email) { should == "fnando.vieira+br@gmail.com" }
    its(:requested_at) { should be_a(Time) }
    its(:payer_id) { should == "D2U7M6PTMJBML" }
    its(:payer_status) { should == "unverified" }
    its(:country) { should == "BR" }
    its(:currency) { should == "BRL" }
    its(:description) { should == "Awesome - Monthly Subscription" }
    its(:ipn_url) { should == "http://example.com/paypal/ipn" }
    its(:agreed?) { should be_true }
  end

  context "when cancelled" do
    use_vcr_cassette "details/cancelled"
    subject {
      ppr = PayPal::Recurring.new(:token => "EC-8J298813NS092694P")
      ppr.checkout_details
    }

    it { should be_valid }
    it { should be_success }

    its(:agreed?) { should be_false }
  end

  context "when failure" do
    use_vcr_cassette("details/failure")
    subject { PayPal::Recurring.new.checkout_details }

    it { should_not be_valid }
    it { should_not be_success }

    its(:errors) { should have(1).item }
  end
end
