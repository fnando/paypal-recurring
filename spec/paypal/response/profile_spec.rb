require "spec_helper"

describe PayPal::Recurring::Response::Profile do
  let(:paypal) { PayPal::Recurring.new(:profile_id => "I-89LD5VEHEVK4") }

  context "when successful" do
    use_vcr_cassette "profile/success"
    subject { paypal.profile }

    it { should_not be_active }

    its(:status) { should == :canceled }
    its(:profile_id) { should == "I-89LD5VEHEVK4" }
    its(:outstanding) { should == :next_billing }
    its(:description) { should == "Awesome - Monthly Subscription" }
    its(:payer_name) { should == "Test User" }
    its(:reference) { should == "1234" }
    its(:failed) { should == "1" }
    its(:start_at) { should be_a(Time) }
    its(:completed) { should == "1" }
    its(:remaining) { should == "18446744073709551615" }
    its(:outstanding_balance) { should == "0.00" }
    its(:failed_count) { should == "0" }
    its(:last_payment_date) { should be_a(Time) }
    its(:last_payment_amount) { should == "9.00" }
    its(:period) { should == :monthly }
    its(:frequency) { should == "1" }
    its(:currency) { should == "USD" }
    its(:amount) { should == "9.00" }
    its(:initial_amount) { should == "0.00" }
  end

  context "when failure" do
    use_vcr_cassette "profile/failure"
    subject { paypal.profile }

    it { should_not be_valid }
    it { should_not be_success }

    its(:errors) { should have(1).item }
  end
end
