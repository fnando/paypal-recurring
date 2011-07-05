module PayPal
  module Recurring
    class Notification
      extend PayPal::Recurring::Utils

      attr_reader :params

      mapping({
        :type           => :txn_type,
        :transaction_id => :txn_id,
        :fee            => [:mc_fee, :payment_fee],
        :reference      => [:rp_invoice_id, :custom, :invoice],
        :payment_id     => :recurring_payment_id,
        :amount         => [:amount, :mc_gross, :payment_gross],
        :currency       => :mc_currency,
        :status         => :payment_status,
        :payment_date   => [:time_created, :payment_date],
        :seller_id      => :receiver_id,
        :email          => :receiver_email,
        :initial_amount => :initial_payment_amount,
        :payer_email    => :payer_email
      })

      def initialize(params = {})
        self.params = params
      end

      def params=(params)
        @params = params.inject({}) do |buffer, (name,value)|
          buffer.merge(name.to_sym => value)
        end
      end

      def express_checkout?
        type == "express_checkout"
      end

      def recurring_payment?
        type == "recurring_payment"
      end

      def recurring_payment_profile?
        type == "recurring_payment_profile_created"
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
        completed? && verified? && email == PayPal::Recurring.email && seller_id == PayPal::Recurring.seller_id
      end

      def completed?
        status == "Completed"
      end

      def next_payment_date
        self.class.convert_to_time(params[:next_payment_date]) if params[:next_payment_date]
      end

      def paid_at
        self.class.convert_to_time(payment_date) if payment_date
      end

      def verified?
        response.body == "VERIFIED"
      end
    end
  end
end
