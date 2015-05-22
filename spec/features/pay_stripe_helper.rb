module PayStripeHelper # credit here: https://gist.github.com/nruth/b2500074749e9f56e0b7

  def subscribe(card_number)
    create(:user, confirmation: true)
    visit "/users/#{User.first.id}/subscribe"
    click_button 'Pay with Card'
    sleep 1
    within_frame 'stripe_checkout_app' do
      page.driver.browser.find_element(:id, 'email').send_keys User.first.email
      split_into_4(card_number).each do |d|
        page.driver.browser.find_element(:id, 'card_number').send_keys(d)
      end
      page.driver.browser.find_element(:id, 'cc-exp').send_keys '12'
      page.driver.browser.find_element(:id, 'cc-exp').send_keys '18'
      page.driver.browser.find_element(:id, 'cc-csc').send_keys '123'
      find('button[type="submit"]').click
    end
    sleep 10
  end

  def split_into_4(string)
    string.chars.each_slice(4).map(&:join)
  end

end

RSpec.configure do |config|
  config.include PayStripeHelper, type: :feature
end
