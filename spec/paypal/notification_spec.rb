require "spec_helper"

describe PayPal::Recurring::Notification do
  context "when successful" do
    use_vcr_cassette "notification/success"

    it "verifies notification" do
      subject.params = {"test_ipn"=>"1", "payment_type"=>"echeck", "payment_date"=>"06:16:11 Jun 27, 2011 PDT", "payment_status"=>"Completed", "pending_reason"=>"echeck", "address_status"=>"confirmed", "payer_status"=>"verified", "first_name"=>"John", "last_name"=>"Smith", "payer_email"=>"buyer@paypalsandbox.com", "payer_id"=>"TESTBUYERID01", "address_name"=>"John Smith", "address_country"=>"United States", "address_country_code"=>"US", "address_zip"=>"95131", "address_state"=>"CA", "address_city"=>"San Jose", "address_street"=>"123, any street", "business"=>"seller@paypalsandbox.com", "receiver_email"=>"seller@paypalsandbox.com", "receiver_id"=>"TESTSELLERID1", "residence_country"=>"US", "item_name"=>"something", "item_number"=>"AK-1234", "quantity"=>"1", "shipping"=>"3.04", "tax"=>"2.02", "mc_currency"=>"USD", "mc_fee"=>"0.44", "mc_gross"=>"12.34", "txn_type"=>"web_accept", "txn_id"=>"116271316", "notify_version"=>"2.1", "custom"=>"xyz123", "invoice"=>"abc1234", "charset"=>"windows-1252", "verify_sign"=>"A12AYqq6LElPcpXaQx48GiroLHnMAoQPnK0Z7aRwXUOpg1GfDaE15mFN"}
      subject.should be_verified
      subject.should be_completed
    end
  end

  context "when failure" do
    use_vcr_cassette "notification/failure"

    it "verifies notification" do
      subject.params = {}
      subject.should_not be_verified
      subject.should_not be_completed
    end
  end
end
