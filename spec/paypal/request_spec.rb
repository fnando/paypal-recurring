require "spec_helper"

describe PayPal::Recurring::Request do
  describe "#client" do
    it "uses SSL" do
      subject.client.use_ssl?.should be_true
    end

    it "verifies certificate" do
      subject.client.verify_mode.should == OpenSSL::SSL::VERIFY_PEER
    end

    it "sets CA file to bundled file" do
      subject.client.ca_file.should == File.expand_path("../../../lib/paypal/recurring/cacert.pem", __FILE__)
      File.should be_file(subject.client.ca_file)
    end
  end

  describe "#post" do
    let(:request) {
      FakeWeb.register_uri :post, "https://api-3t.sandbox.paypal.com/nvp", :status => 200
      subject.run(:checkout)
      CGI.parse(FakeWeb.last_request.body)
    }

    it "sets action" do
      request["METHOD"].first.should == "SetExpressCheckout"
    end

    it "sets username" do
      request["USER"].first.should == PayPal::Recurring.username
    end

    it "sets password" do
      request["PWD"].first.should == PayPal::Recurring.password
    end

    it "sets signature" do
      request["SIGNATURE"].first.should == PayPal::Recurring.signature
    end

    it "sets API version" do
      request["VERSION"].first.should == PayPal::Recurring.api_version
    end

    it "sets user agent" do
      FakeWeb.last_request["User-Agent"].should == "PayPal::Recurring/#{PayPal::Recurring::Version::STRING}"
    end
  end

  describe "#normalize_params" do
    it "normalizes method" do
      subject.normalize_params(:method => "some method").should == {:METHOD => "some method"}
    end

    it "normalizes return_url" do
      subject.normalize_params(:return_url => "http://example.com").should == {:RETURNURL => "http://example.com"}
    end

    it "normalizes cancel_url" do
      subject.normalize_params(:cancel_url => "http://example.com").should == {:CANCELURL => "http://example.com"}
    end

    it "normalizes amount" do
      subject.normalize_params(:amount => "9.00").should == {:PAYMENTREQUEST_0_AMT => "9.00", :AMT => "9.00"}
    end

    it "normalizes currency" do
      subject.normalize_params(:currency => "USD").should == {:CURRENCYCODE => "USD", :PAYMENTREQUEST_0_CURRENCYCODE => "USD"}
    end

    it "normalizes description" do
      subject.normalize_params(:description => "Awesome").should == {:DESC => "Awesome", :PAYMENTREQUEST_0_DESC => "Awesome", :L_BILLINGAGREEMENTDESCRIPTION0 => "Awesome"}
    end

    it "normalizes ipn url" do
      subject.normalize_params(:ipn_url => "http://example.com").should == {:PAYMENTREQUEST_0_NOTIFYURL => "http://example.com", :NOTIFYURL => "http://example.com"}
    end

    it "normalizes period" do
      subject.normalize_params(:period => :monthly).should == {:BILLINGPERIOD => "Month"}
      subject.normalize_params(:period => :daily).should == {:BILLINGPERIOD => "Day"}
      subject.normalize_params(:period => :yearly).should == {:BILLINGPERIOD => "Year"}
    end

    it "normalizes start at" do
      date = Time.parse("2011-06-26 15:13:00")
      subject.normalize_params(:start_at => date).should == {:PROFILESTARTDATE => "2011-06-26T15:13:00Z"}
    end

    it "normalizes outstanding" do
      subject.normalize_params(:outstanding => :next_billing).should == {:AUTOBILLOUTAMT => "AddToNextBilling"}
      subject.normalize_params(:outstanding => :no_auto).should == {:AUTOBILLOUTAMT => "NoAutoBill"}
    end

    it "normalizes action" do
      subject.normalize_params(:action => :cancel).should == {:ACTION => "Cancel"}
      subject.normalize_params(:action => :suspend).should == {:ACTION => "Suspend"}
      subject.normalize_params(:action => :reactivate).should == {:ACTION => "Reactivate"}
    end

    it "normalizes initial amount" do
      subject.normalize_params(:initial_amount => "9.00").should == {:INITAMT => "9.00"}
    end

    it "normalizes initial amount action" do
      subject.normalize_params(:initial_amount_action => :cancel).should == {:FAILEDINITAMTACTION => "CancelOnFailure"}
      subject.normalize_params(:initial_amount_action => :continue).should == {:FAILEDINITAMTACTION => "ContinueOnFailure"}
    end

    it "normalizes reference" do
      subject.normalize_params(:reference => "abc").should == {:PROFILEREFERENCE => "abc", :PAYMENTREQUEST_0_CUSTOM => "abc", :PAYMENTREQUEST_0_INVNUM => "abc"}
    end

    it "normalizes locale" do
      subject.normalize_params(:locale => :us).should == {:LOCALECODE => "US"}
    end
  end
end
