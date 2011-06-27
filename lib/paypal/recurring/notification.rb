module PayPal
  module Recurring
    class Notification
      attr_reader :params

      def initialize(params = {})
        self.params = params
      end

      def params=(params)
        @params = params.inject({}) do |buffer, (name,value)|
          buffer.merge(name.to_sym => value)
        end
      end

      def request
        @request ||= PayPal::Recurring::Request.new.tap do |request|
          request.uri = URI.parse("#{PayPal::Recurring.site_endpoint}?cmd=_notify-validate")
        end
      end

      def response
        @response ||= request.post(params.merge(:cmd => "_notify-validate"))
      end

      def valid?
        completed? && verified? && params[:receiver_email] == PayPal::Recurring.email && params[:receiver_id] == PayPal::Recurring.seller_id && params[:txn_type] == "recurring_payment"
      end

      def completed?
        status == "Completed"
      end

      def transaction_id
        params[:txn_id]
      end

      def fee
        params[:mc_currency]
      end

      def reference
        params[:rp_invoice_id]
      end

      def payment_id
        params[:recurring_payment_id]
      end

      def next_payment_date
        Time.parse(params[:next_payment_date]) if params[:next_payment_date]
      end

      def paid_at
        Time.parse params[:time_created] if params[:time_created]
      end

      def amount
        params[:amount]
      end

      def currency
        params[:mc_currency]
      end

      def status
        params[:payment_status]
      end

      def verified?
        response.body == "VERIFIED"
      end
    end
  end
end
