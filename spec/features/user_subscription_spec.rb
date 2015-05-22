require_relative 'features_helper'

describe 'Subscribing', type: :feature, js: true do
  context 'a confirmed user' do
    context "by visiting the subscription page" do
      context 'and selecting "Pay with Card"' do

        before do
          create(:user, confirmation: true)
          visit "/users/#{User.first.id}/subscribe"
          click_button 'Pay with Card'
          sleep 1
          # credit here: https://gist.github.com/nruth/b2500074749e9f56e0b7
          within_frame 'stripe_checkout_app' do
            find_element(:id, 'email').send_keys User.first.email
            4.times { find_element(:id, 'card_number').send_keys('4242') }
            find_element(:id, 'cc-exp').send_keys '12'
            find_element(:id, 'cc-exp').send_keys '18'
            find_element(:id, 'cc-csc').send_keys '123'
            find('button[type="submit"]').click
          end
          sleep 10
        end

        after(:suite) { Stripe::Customer.all.each &:delete } # tidy up

        context "and making a successful payment" do
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

        end
      end
    end
  end

end
