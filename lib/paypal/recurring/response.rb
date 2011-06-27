module PayPal
  module Recurring
    module Response
      autoload :Base, "paypal/recurring/response/base"
      autoload :Checkout, "paypal/recurring/response/checkout"
      autoload :Details, "paypal/recurring/response/details"
      autoload :Payment, "paypal/recurring/response/payment"
      autoload :ManageProfile, "paypal/recurring/response/manage_profile"
      autoload :Profile, "paypal/recurring/response/profile"

      RESPONDERS = {
        :checkout       => "Checkout",
        :details        => "Details",
        :payment        => "Payment",
        :profile        => "Profile",
        :create_profile => "ManageProfile",
        :manage_profile => "ManageProfile"
      }

      def self.process(method, response)
        response_class = PayPal::Recurring::Response.const_get(RESPONDERS[method])
        response_class.new(response)
      end
    end
  end
end
