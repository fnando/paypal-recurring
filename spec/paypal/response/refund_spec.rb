require "spec_helper"

describe PayPal::Recurring::Response::Profile do
  let(:paypal) {
    PayPal::Recurring.new({
      :profile_id     => "I-1BASBJ9C9WBS",
      :transaction_id => "4GP25924UB013401J",
      :reference      => "12345",
      :refund_type    => :full,
      :amount         => "9.00",
      :currency       => "BRL"
    })
  }

  context "when successful" do
    use_vcr_cassette "refund/success"
    subject { paypal.refund }

    its(:transaction_id) { should eql("5MM61417CA010574T") }
    its(:fee_amount) { should eql("0.71") }
    its(:gross_amount) { should eql("9.00") }
    its(:net_amount) { should eql("8.29") }
    its(:amount) { should eql("9.00") }
    its(:currency) { should eql("BRL") }
  end

  context "when failure" do
    use_vcr_cassette "refund/failure"
    subject { paypal.refund }

    its(:errors) { should have(1).items }
  end
end
