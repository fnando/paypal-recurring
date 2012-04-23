require "spec_helper"

describe PayPal::Recurring::Response::Profile do
  context "when successful" do
    use_vcr_cassette "create_profile/success"

    subject {
      ppr = PayPal::Recurring.new({
        :amount                => "9.00",
        :initial_amount        => "9.00",
        :initial_amount_action => :cancel,
        :currency              => "BRL",
        :description           => "Awesome - Monthly Subscription",
        :ipn_url               => "http://example.com/paypal/ipn",
        :frequency             => 1,
        :token                 => "EC-47J551124P900104V",
        :period                => :monthly,
        :reference             => "1234",
        :payer_id              => "D2U7M6PTMJBML",
        :start_at              => Time.now,
        :failed                => 1,
        :outstanding           => :next_billing
      })
      ppr.create_recurring_profile
    }

    it { should be_valid }

    its(:profile_id) { should == "I-W4FNTE6EXJ2W" }
    its(:status) { should == "ActiveProfile" }
    its(:errors) { should be_empty }
  end

  context "when failure" do
    use_vcr_cassette("create_profile/failure")
    subject { PayPal::Recurring.new.create_recurring_profile }

    it { should_not be_valid }
    its(:errors) { should have(5).items }
  end
end
