describe 'Subscribing', type: :feature, js: true do

  # before do
  #   confirmed_user = create(:user, confirmation: true)
  # end

  context 'a confirmed user' do
    context "by visiting the subscription page" do
      it 'displays a "Pay with Card" button' do
        confirmed_user = create(:user, confirmation: true)
        user = User.first
        visit "/users/#{user.id}/subscribe"
        expect(page).to have_button 'Pay with Card'
      end

      context 'and selecting "Pay with Card"' do
        it 'displays the Stripe checkout form' do
          confirmed_user = create(:user, confirmation: true)
          user = User.first
          visit "/users/#{user.id}/subscribe"
          click_button 'Pay with Card'
          sleep(0.7)
          within_frame 'stripe_checkout_app' do
            expect(page).to have_content 'Pay £512.50'
          end
        end

        context "making a successful payment" do
          it 'will be subscribed' do
            confirmed_user = create(:user, confirmation: true)
            user = User.first
            visit "/users/#{user.id}/subscribe"
            click_button 'Pay with Card'
            sleep(0.7) # wait for the js to create the popup in response to pressing the button
            within_frame 'stripe_checkout_app' do # must be selenium
              page.driver.browser.find_element(:id, 'email').send_keys 'test2@example.com'
              4.times {page.driver.browser.find_element(:id, 'card_number').send_keys('4242')}
              page.driver.browser.find_element(:id, 'cc-exp').send_keys '5'
              page.driver.browser.find_element(:id, 'cc-exp').send_keys '18'
              page.driver.browser.find_element(:id, 'cc-csc').send_keys '123'
              find('button[type="submit"]').click
            end
            sleep 6
            expect(user.confirmation).to be_truthy
          end

          it 'will be directed to the charge page' do
            confirmed_user = create(:user, confirmation: true)
            user = User.first
            visit "/users/#{user.id}/subscribe"
            click_button 'Pay with Card'
            sleep(0.7) # wait for the js to create the popup in response to pressing the button
            within_frame 'stripe_checkout_app' do # must be selenium
              page.driver.browser.find_element(:id, 'email').send_keys 'test2@example.com'
              4.times {page.driver.browser.find_element(:id, 'card_number').send_keys('4242')}
              page.driver.browser.find_element(:id, 'cc-exp').send_keys '5'
              page.driver.browser.find_element(:id, 'cc-exp').send_keys '18'
              page.driver.browser.find_element(:id, 'cc-csc').send_keys '123'
              find('button[type="submit"]').click
            end
            sleep 6
            expect(current_path).to eq "/users/#{user.id}/payment"
          end

        end
      end
    end
  end

end
