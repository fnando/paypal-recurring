require "spec_helper"

describe PayPal::Recurring::Response::Checkout do
  context "when successful" do
    use_vcr_cassette "checkout/success"

    subject {
      ppr = PayPal::Recurring.new({
        :return_url         => "http://example.com/thank_you",
        :cancel_url         => "http://example.com/canceled",
        :ipn_url            => "http://example.com/paypal/ipn",
        :description        => "Awesome - Monthly Subscription",
        :amount             => "9.00",
        :currency           => "USD"
      })

      ppr.checkout
    }

    its(:valid?) { should be_true }
    its(:errors) { should be_empty }
    its(:checkout_url) { should == "#{PayPal::Recurring.site_endpoint}?cmd=_express-checkout&token=EC-6K296451S2213041J&useraction=commit" }
  end

  context "when failure" do
    use_vcr_cassette("checkout/failure")
    subject { PayPal::Recurring.new.checkout }

    its(:valid?) { should be_false }
    its(:errors) { should have(3).items }
  end
end
