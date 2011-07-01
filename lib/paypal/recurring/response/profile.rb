module PayPal
  module Recurring
    module Response
      class Profile < Base
        mapping(
          :profile_id          => :PROFILEID,
          :status              => :STATUS,
          :description         => :DESC,
          :outstanding         => :AUTOBILLOUTAMT,
          :failed              => :MAXFAILEDPAYMENTS,
          :payer_name          => :SUBSCRIBERNAME,
          :start_at            => :PROFILESTARTDATE,
          :reference           => :PROFILEREFERENCE,
          :completed           => :NUMCYCLESCOMPLETED,
          :remaining           => :NUMCYCLESREMAINING,
          :outstanding_balance => :OUTSTANDINGBALANCE,
          :failed_count        => :FAILEDPAYMENTCOUNT,
          :last_payment_date   => :LASTPAYMENTDATE,
          :last_payment_amount => :LASTPAYMENTAMT,
          :period              => :BILLINGPERIOD,
          :frequency           => :BILLINGFREQUENCY,
          :currency            => :CURRENCYCODE,
          :amount              => :AMT,
          :initial_amount      => :AGGREGATEOPTIONALAMT
        )

        OUTSTANDING = {
          "AddToNextBilling" => :next_billing,
          "NoAutoBill" => :no_auto
        }

        STATUS = {
          "Cancelled" => :canceled,
          "Active"    => :active,
          "Suspended" => :suspended
        }

        PERIOD = {
          "Month" => :monthly,
          "Year"  => :yearly,
          "Day"   => :daily
        }

        def active?
          status == :active
        end

        private
        def build_outstanding(value)
          OUTSTANDING.fetch(value, value)
        end

        def build_status(value)
          STATUS.fetch(value, value)
        end

        def build_date(string)
          Time.parse(string)
        end

        def build_period(value)
          PERIOD.fetch(value, value)
        end

        alias_method :build_start_at, :build_date
        alias_method :build_last_payment_date, :build_date
      end
    end
  end
end
