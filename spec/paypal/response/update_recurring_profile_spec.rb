require "spec_helper"

describe PayPal::Recurring::Response::Profile do
  context "when successful" do
    use_vcr_cassette "update_profile/success"

    subject {
      ppr = PayPal::Recurring.new({
        :amount                => "19.00",
        :currency              => "USD",
        :description           => "Awesome - Monthly Subscription",
        :ipn_url               => "http://example.com/paypal/ipn",
        :reference             => "1234",
        :note                  => "Changed Plan",
        :profile_id            => "I-89LD5VEHEVK4",
        :outstanding           => :next_billing,
        :start_at              => Time.now,        
      })
      ppr.update_recurring_profile
    }

    it { should be_valid }

    its(:profile_id) { should == "I-89LD5VEHEVK4" }
    its(:status) { should == "ActiveProfile" }
    its(:errors) { should be_empty }
  end

  context "when failure" do
    use_vcr_cassette("update_profile/failure")
    subject { PayPal::Recurring.new.create_recurring_profile }

    it { should_not be_valid }
    its(:errors) { should have(5).items }
  end
end