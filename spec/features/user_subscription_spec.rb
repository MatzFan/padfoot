describe 'Subscribing', type: :feature, js: true do
  context 'a confirmed user' do
    context "by visiting the subscription page" do
      context 'and selecting "Pay with Card"' do

        before do
          create(:user, confirmation: true)
          visit "/users/#{User.first.id}/subscribe"
          click_button 'Pay with Card'
          sleep 0.7
          within_frame 'stripe_checkout_app' do
            page.driver.browser.find_element(:id, 'email').send_keys User.first.email
            4.times {page.driver.browser.find_element(:id, 'card_number').send_keys('4242')}
            page.driver.browser.find_element(:id, 'cc-exp').send_keys '5'
            page.driver.browser.find_element(:id, 'cc-exp').send_keys '18'
            page.driver.browser.find_element(:id, 'cc-csc').send_keys '123'
            find('button[type="submit"]').click
          end
          sleep 12
        end

        context "and making a successful payment" do
          it 'will be subscribed' do
            expect(User.first.subscription).to be_truthy
          end

          it 'will assign the stripe customer id to the user' do
            expect(User.first.stripe_cust_id).not_to be_blank
          end

          it 'will be directed to the login page' do
            expect(current_path).to eq "/login"
          end

        end
      end
    end
  end

end
