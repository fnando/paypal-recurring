module PayPal
  module Recurring
    class Request
      METHODS = {
        :checkout       => "SetExpressCheckout",
        :payment        => "DoExpressCheckoutPayment",
        :details        => "GetExpressCheckoutDetails",
        :create_profile => "CreateRecurringPaymentsProfile",
        :profile        => "GetRecurringPaymentsProfileDetails",
        :manage_profile => "ManageRecurringPaymentsProfileStatus"
      }

      INITIAL_AMOUNT_ACTIONS = {
        :cancel   => "CancelOnFailure",
        :continue => "ContinueOnFailure"
      }

      ACTIONS = {
        :cancel     => "Cancel",
        :suspend    => "Suspend",
        :reactivate => "Reactivate"
      }

      PERIOD = {
        :daily   => "Day",
        :monthly => "Month",
        :yearly  => "Year"
      }

      OUTSTANDING = {
        :next_billing => "AddToNextBilling",
        :no_auto      => "NoAutoBill"
      }

      ATTRIBUTES = {
        :action                => "ACTION",
        :amount                => ["PAYMENTREQUEST_0_AMT", "AMT"],
        :billing_type          => "L_BILLINGTYPE0",
        :cancel_url            => "CANCELURL",
        :currency              => ["PAYMENTREQUEST_0_CURRENCYCODE", "CURRENCYCODE"],
        :description           => ["DESC", "PAYMENTREQUEST_0_DESC", "L_BILLINGAGREEMENTDESCRIPTION0"],
        :email                 => "EMAIL",
        :failed                => "MAXFAILEDPAYMENTS",
        :frequency             => "BILLINGFREQUENCY",
        :initial_amount        => "INITAMT",
        :initial_amount_action => "FAILEDINITAMTACTION",
        :ipn_url               => ["PAYMENTREQUEST_0_NOTIFYURL", "NOTIFYURL"],
        :locale                => "LOCALECODE",
        :method                => "METHOD",
        :no_shipping           => "NOSHIPPING",
        :outstanding           => "AUTOBILLOUTAMT",
        :password              => "PWD",
        :payer_id              => "PAYERID",
        :payment_action        => "PAYMENTREQUEST_0_PAYMENTACTION",
        :period                => "BILLINGPERIOD",
        :profile_id            => "PROFILEID",
        :reference             => ["PROFILEREFERENCE", "PAYMENTREQUEST_0_CUSTOM", "PAYMENTREQUEST_0_INVNUM"],
        :return_url            => "RETURNURL",
        :signature             => "SIGNATURE",
        :start_at              => "PROFILESTARTDATE",
        :token                 => "TOKEN",
        :username              => "USER",
        :version               => "VERSION",
      }

      CA_FILE = File.dirname(__FILE__) + "/cacert.pem"

      attr_accessor :uri

      # Do a POST request to PayPal API.
      # The +method+ argument is the name of the API method you want to invoke.
      # For instance, if you want to request a new checkout token, you may want
      # to do something like:
      #
      #   response = request.run(:express_checkout)
      #
      # We normalize the methods name. For a list of what's being covered, refer to
      # PayPal::Recurring::Request::METHODS constant.
      #
      # The params hash can use normalized names. For a list, check the
      # PayPal::Recurring::Request::ATTRIBUTES constant.
      #
      def run(method, params = {})
        params = prepare_params(params.merge(:method => METHODS.fetch(method, method.to_s)))
        response = post(params)
        Response.process(method, response)
      end

      #
      #
      def request
        @request ||= Net::HTTP::Post.new(uri.request_uri).tap do |http|
          http["User-Agent"] = "PayPal::Recurring/#{PayPal::Recurring::Version::STRING}"
        end
      end

      #
      #
      def post(params = {})
        request.form_data = params
        client.request(request)
      end

      # Join params and normalize attribute names.
      #
      def prepare_params(params) # :nodoc:
        normalize_params default_params.merge(params)
      end

      # Parse current API url.
      #
      def uri # :nodoc:
        @uri ||= URI.parse(PayPal::Recurring.api_endpoint)
      end

      def client
        @client ||= begin
          Net::HTTP.new(uri.host, uri.port).tap do |http|
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_PEER
            http.ca_file = CA_FILE
          end
        end
      end

      def default_params
        {
          :username    => PayPal::Recurring.username,
          :password    => PayPal::Recurring.password,
          :signature   => PayPal::Recurring.signature,
          :version     => PayPal::Recurring.api_version
        }
      end

      def normalize_params(params)
        params.inject({}) do |buffer, (name, value)|
          attr_names = [ATTRIBUTES[name.to_sym]].flatten.compact
          attr_names << name if attr_names.empty?

          attr_names.each do |attr_name|
            buffer[attr_name.to_sym] = respond_to?("build_#{name}") ? send("build_#{name}", value) : value
          end

          buffer
        end
      end

      def build_period(value) # :nodoc:
        PERIOD.fetch(value.to_sym, value) if value
      end

      def build_start_at(value) # :nodoc:
        value.respond_to?(:strftime) ? value.strftime("%Y-%m-%dT%H:%M:%SZ") : value
      end

      def build_outstanding(value) # :nodoc:
        OUTSTANDING.fetch(value.to_sym, value) if value
      end

      def build_action(value) # :nodoc:
        ACTIONS.fetch(value.to_sym, value) if value
      end

      def build_initial_amount_action(value) # :nodoc:
        INITIAL_AMOUNT_ACTIONS.fetch(value.to_sym, value) if value
      end

      def build_locale(value) # :nodoc:
        value.to_s.upcase
      end
    end
  end
end
