module PayPal
  module Recurring
    module Response
      class Refund < Base
        mapping(
          :transaction_id => :REFUNDTRANSACTIONID,
          :fee_amount     => :FEEREFUNDAMT,
          :gross_amount   => :GROSSREFUNDAMT,
          :net_amount     => :NETREFUNDAMT,
          :amount         => :TOTALREFUNDEDAMOUNT,
          :currency       => :CURRENCYCODE,
          :info           => :REFUNDINFO,
          :status         => :REFUNDSTATUS,
          :pending_reason => :PENDINGREASON
        )

        def completed?
          params[:REFUNDSTATUS] == "instant"
        end
      end
    end
  end
end