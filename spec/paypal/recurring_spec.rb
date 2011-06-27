require "spec_helper"

describe PayPal::Recurring do
  describe ".new" do
    it "instantiates PayPal::Recurring::Base" do
      PayPal::Recurring.new.should be_a(PayPal::Recurring::Base)
    end
  end

  describe ".version" do
    it "returns PayPal's API version" do
      PayPal::Recurring.api_version.should eq("72.0")
    end
  end

  describe ".configure" do
    it "yields PayPal::Recurring" do
      PayPal::Recurring.configure do |config|
        config.should be(PayPal::Recurring)
      end
    end

    it "sets attributes" do
      PayPal::Recurring.configure do |config|
        config.sandbox = false
      end

      PayPal::Recurring.sandbox.should be_false
    end
  end

  describe ".sandbox?" do
    it "detects sandbox" do
      PayPal::Recurring.sandbox = true
      PayPal::Recurring.should be_sandbox
    end

    it "ignores sandbox" do
      PayPal::Recurring.sandbox = false
      PayPal::Recurring.should_not be_sandbox
    end
  end

  describe ".environment" do
    it "returns production" do
      PayPal::Recurring.sandbox = false
      PayPal::Recurring.environment.should eq(:production)
    end

    it "returns sandbox" do
      PayPal::Recurring.sandbox = true
      PayPal::Recurring.environment.should eq(:sandbox)
    end
  end

  describe ".api_endpoint" do
    it "returns url" do
      PayPal::Recurring.api_endpoint.should_not be_nil
      PayPal::Recurring.api_endpoint.should == PayPal::Recurring.endpoints[:api]
    end
  end

  describe ".site_endpoint" do
    it "returns url" do
      PayPal::Recurring.site_endpoint.should_not be_nil
      PayPal::Recurring.site_endpoint.should == PayPal::Recurring.endpoints[:site]
    end
  end

  describe ".endpoints" do
    it "returns production's" do
      PayPal::Recurring.sandbox = false
      PayPal::Recurring.endpoints.should eq(PayPal::Recurring::ENDPOINTS[:production])
    end

    it "returns sandbox's" do
      PayPal::Recurring.sandbox = true
      PayPal::Recurring.endpoints.should eq(PayPal::Recurring::ENDPOINTS[:sandbox])
    end
  end
end
