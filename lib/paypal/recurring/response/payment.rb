module PayPal
  module Recurring
    module Response
      class Payment < Base
        mapping(
          :status    => :PAYMENTINFO_0_PAYMENTSTATUS,
          :amount    => :PAYMENTINFO_0_AMT,
          :fees      => :PAYMENTINFO_0_FEEAMT,
          :seller_id => :PAYMENTINFO_0_SECUREMERCHANTACCOUNTID,
          :reference => [:PROFILEREFERENCE, :PAYMENTREQUEST_0_CUSTOM, :PAYMENTREQUEST_0_INVNUM]
        )

        def completed?
          params[:PAYMENTINFO_0_PAYMENTSTATUS] == "Completed"
        end

        def approved?
          params[:PAYMENTINFO_0_ACK] == "Success"
        end
      end
    end
  end
end
