module PayPal
  module Recurring
    module Response
      class Refund < Base
        mapping(
          :transaction_id => :REFUNDTRANSACTIONID,
          :feerefund      => :FEEREFUNDAMT,
          :grossrefund    => :GROSSREFUNDAMT,
          :netrefund      => :NETREFUNDAMT,
          :amount         => :TOTALREFUNDEDAMT,
          :cunnrecy       => :CURRENCYCODE,
          :info           => :REFUNDINFO,
          :status         => :REFUNDSTATUS,
          :pendingreason  => :PENDINGREASON,
        )

        def completed?
          params[:REFUNDSTATUS] == "instant"
        end
      end
    end
  end
end