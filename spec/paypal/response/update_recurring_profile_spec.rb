require "spec_helper"

describe PayPal::Recurring::Response::Profile do
  context "when successful" do
    use_vcr_cassette "update_profile/success"

    let(:paypal) {
      PayPal::Recurring.new({
        :description => "Awesome - Monthly Subscription (Updated)",
        :amount      => "10.00",
        :currency    => "BRL",
        :note        => "Changed Plan",
        :profile_id  => "I-6BWVV63V49JT"
      })
    }

    subject { paypal.update_recurring_profile }

    it { should be_valid }
    its(:profile_id) { should == "I-6BWVV63V49JT" }
    its(:errors) { should be_empty }
  end

  context "updated profile" do
    use_vcr_cassette "update_profile/profile"

    let(:paypal) { PayPal::Recurring.new(:profile_id => "I-6BWVV63V49JT") }
    subject { paypal.profile }

    its(:amount) { should eql("10.00") }
    its(:description) { should eql("Awesome - Monthly Subscription (Updated)") }
  end

  context "when failure" do
    use_vcr_cassette("update_profile/failure")

    let(:paypal) {
      PayPal::Recurring.new({
        :profile_id => "I-W4FNTE6EXJ2W",
        :amount     => "10.00"
      })
    }
    subject { paypal.update_recurring_profile }

    it { should_not be_valid }
    its(:errors) { should have(1).items }
  end
end