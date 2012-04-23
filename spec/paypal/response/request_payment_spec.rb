require "spec_helper"

describe PayPal::Recurring::Response::Payment do
  context "when successful" do
    use_vcr_cassette "payment/success"

    subject {
      ppr = PayPal::Recurring.new({
        :description => "Awesome - Monthly Subscription",
        :amount      => "9.00",
        :currency    => "BRL",
        :payer_id    => "D2U7M6PTMJBML",
        :token       => "EC-7DE19186NP195863W",
      })
      ppr.request_payment
    }

    it { should be_valid }
    it { should be_completed }
    it { should be_approved }

    its(:errors) { should be_empty }
  end

  context "when failure" do
    use_vcr_cassette("payment/failure")
    subject { PayPal::Recurring.new.request_payment }

    it { should_not be_valid }
    it { should_not be_completed }
    it { should_not be_approved }

    its(:errors) { should have(2).items }
  end
end
