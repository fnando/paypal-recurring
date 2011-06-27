require "spec_helper"

describe PayPal::Recurring::Response::Details do
  context "when successful" do
    use_vcr_cassette "details/success"

    subject {
      ppr = PayPal::Recurring.new(:token => "EC-7B902269MT603740W")
      ppr.checkout_details
    }

    it { should be_valid }
    it { should be_success }

    its(:errors) { should be_empty }
    its(:status) { should == "PaymentActionNotInitiated" }
    its(:email) { should == "buyer_1308979708_per@simplesideias.com.br" }
    its(:requested_at) { should be_a(Time) }
    its(:email) { should == "buyer_1308979708_per@simplesideias.com.br" }
    its(:payer_id) { should == "WTTS5KC2T46YU" }
    its(:payer_status) { should == "verified" }
    its(:country) { should == "US" }
    its(:currency) { should == "USD" }
    its(:description) { should == "Awesome - Monthly Subscription" }
    its(:ipn_url) { should == "http://example.com/paypal/ipn" }
    its(:agreed?) { should be_true }
  end

  context "when cancelled" do
    use_vcr_cassette "details/cancelled"
    subject {
      ppr = PayPal::Recurring.new(:token => "EC-365619347A138351P")
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
