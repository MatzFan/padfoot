require_relative 'features_helper'
require_relative 'pay_stripe_helper'

describe 'Subscribing', type: :feature, js: true do

  after(:suite) { Stripe::Customer.all(limit: 100).each &:delete } # tidy up

  context 'a confirmed user' do
    context "by visiting the subscription page" do
      context 'and selecting "Pay with Card"' do

        before(:each) { click_checkout_button }

        context "and making an unsuccessful payment" do

          before(:each) { checkout(card_number: '4000000000000002') }

          it "will remain on the user's subscription page" do
            expect(current_path).to eq "/users/#{User.first.id}/subscribe"
          end

        end # of unsuccessful payment

        context "and making a successful payment" do

          before(:each) { checkout } # user default card details

          it 'will assign the stripe customer id to the user' do
            expect(User.first.stripe_cust_id).not_to be_blank
          end

          it 'will be subscribed to the annual plan' do
            customer = Stripe::Customer.retrieve(User.first.stripe_cust_id)
            expect(customer.subscriptions.first.plan.id).to eq('annual')
          end

          it 'will be directed to the login page' do
            expect(current_path).to eq "/login"
          end

          context 'and logging in' do
            it 'should be successful' do
              user = User.first
              fill_in('email', with: user.email)
              fill_in('password', with: user.password)
              click_button 'Sign in'
              expect(current_path).to eq '/applications/index'
            end
          end

        end # of making a successful payment
      end
    end
  end

end
