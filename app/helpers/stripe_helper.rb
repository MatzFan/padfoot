# stripe API helper
module Padfoot
  # app
  class App
    # Stripe helper
    module StripeHelper
      def annual_subscription_cost_pence
        Stripe::Plan.retrieve('annual').amount
      end
    end

    helpers StripeHelper
  end
end
