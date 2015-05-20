describe 'Subscribing', type: :feature, js: true do
  context 'a confirmed user' do
    context "by visiting the subscription page" do

      def enter_card_details
        within_frame 'stripe_checkout_app' do # must be selenium
          page.driver.browser.find_element(:id, 'email').send_keys 'test@example.com'
          4.times {page.driver.browser.find_element(:id, 'card_number').send_keys('4242')}
          page.driver.browser.find_element(:id, 'cc-exp').send_keys '5'
          page.driver.browser.find_element(:id, 'cc-exp').send_keys '18'
          page.driver.browser.find_element(:id, 'cc-csc').send_keys '123'
          find('button[type="submit"]').click
        end
        sleep 6
      end

      before do
        create(:user, confirmation: true)
        visit "/users/#{User.first.id}/subscribe"
        click_button 'Pay with Card'
        sleep 0.7
      end

      context 'and selecting "Pay with Card"' do
        it 'displays the Stripe checkout form' do
          within_frame 'stripe_checkout_app' do
            expect(page).to have_content 'Pay £512.50'
          end
        end

        context "and making a successful payment" do
          it 'will be subscribed' do
            enter_card_details
            expect(User.first.subscription).to be_truthy
          end

          it 'will assign the stripe customer id to the user' do
            enter_card_details
            expect(User.first.stripe_cust_id).not_to be_blank
          end

          it 'will be directed to the charge page' do
            enter_card_details
            expect(current_path).to eq "/users/#{User.first.id}/payment"
          end

        end
      end
    end
  end

end
