module Padfoot
  class App
    module StripeHelper

      def annual_subscription_cost_pence
        Stripe::Plan.retrieve('annual').amount
      end

    end

    helpers StripeHelper
  end
end
