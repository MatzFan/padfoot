module Padfoot
  class App
    module StripeHelper
      def annual_subscription_cost_pence
        51250
      end
    end

    helpers StripeHelper
  end
end
