module PayPal
  module Recurring
    module Response
      class ManageProfile < Base
        mapping(
          :profile_id => :PROFILEID,
          :status     => :PROFILESTATUS
        )
      end
    end
  end
end
