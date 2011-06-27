module PayPal
  module Recurring
    module Response
      class Checkout < Base
        def checkout_url
          "#{PayPal::Recurring.site_endpoint}?cmd=_express-checkout&token=#{token}"
        end
      end
    end
  end
end
