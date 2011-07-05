require "spec_helper"

describe PayPal::Recurring::Notification do
  it "detects express checkout" do
    subject.params[:txn_type] = "express_checkout"
    subject.should be_express_checkout
  end

  it "detects recurring payment" do
    subject.params[:txn_type] = "recurring_payment"
    subject.should be_recurring_payment
  end

  it "detects recurring payment profile" do
    subject.params[:txn_type] = "recurring_payment_profile_created"
    subject.should be_recurring_payment_profile
  end

  it "normalizes payment date" do
    subject.params[:payment_date] = "20:37:06 Jul 04, 2011 PDT" # PDT = -0700
    subject.paid_at.strftime("%Y-%m-%d %H:%M:%S").should == "2011-07-05 03:37:06"
  end

  it "returns currency" do
    subject.params[:mc_currency] = "BRL"
    subject.currency.should == "BRL"
  end

  describe "#payment_date" do
    it "returns date from time_created field" do
      subject.params[:time_created] = "2011-07-05"
      subject.payment_date.should == "2011-07-05"
    end

    it "returns date from payment_date field" do
      subject.params[:payment_date] = "2011-07-05"
      subject.payment_date.should == "2011-07-05"
    end
  end

  describe "#fee" do
    it "returns fee from mc_fee field" do
      subject.params[:mc_fee] = "0.56"
      subject.fee.should == "0.56"
    end

    it "returns fee from payment_fee field" do
      subject.params[:payment_fee] = "0.56"
      subject.fee.should == "0.56"
    end
  end

  describe "#amount" do
    it "returns amount from amount field" do
      subject.params[:amount] = "9.00"
      subject.amount.should == "9.00"
    end

    it "returns amount from mc_gross field" do
      subject.params[:mc_gross] = "9.00"
      subject.amount.should == "9.00"
    end

    it "returns amount from payment_gross field" do
      subject.params[:payment_gross] = "9.00"
      subject.amount.should == "9.00"
    end
  end

  describe "#reference" do
    it "returns from recurring IPN" do
      subject.params[:rp_invoice_id] = "abc"
      subject.reference.should == "abc"
    end

    it "returns from custom field" do
      subject.params[:custom] = "abc"
      subject.reference.should == "abc"
    end

    it "returns from invoice field" do
      subject.params[:invoice] = "abc"
      subject.reference.should == "abc"
    end
  end

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
