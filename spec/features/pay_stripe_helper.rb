# credit here: https://gist.github.com/nruth/b2500074749e9f56e0b7
module PayStripeHelper
  PASSWORD = 'password'.freeze
  FIELD_IDS = %w(email card_number cc-exp cc-csc).freeze
  # keys must be same as FIELD_IDS
  CHECKOUT_DEFAULTS = { :email => 'test@example.com',
                        :card_number => '4242424242424242',
                        :'cc-exp' => '1218', # month & year
                        :'cc-csc' => '123' }.freeze

  def enable_stripe_event_capture
    port = Padrino::Application.settings.port
    dn = '/dev/null'
    pid = spawn("ultrahook stripe #{port}/stripe_events", out: dn, err: dn)
    Process.detach pid
    pid # return pid
  end

  def click_checkout_button
    create(:user, password: PASSWORD, confirmation: true)
    visit "/users/#{User.first.id}/subscribe"
    click_button 'Pay with Card'
    sleep 1
  end

  def checkout(opts = {})
    opts = CHECKOUT_DEFAULTS.merge opts
    sleep 7 # wait for frame to render - flaky..
    within_frame 'stripe_checkout_app' do # selenium
      enter('email', opts[:email])
      opts[:card_number].chars.each_slice(4) do |digits|
        enter('card_number', digits)
        sleep 0.1
      end
      opts[:'cc-exp'].chars.each_slice(2) do |digits| # month then year
        enter('cc-exp', digits)
      end
      enter('cc-csc', opts[:'cc-csc'])
      find('button[type="submit"]').click
    end
    sleep 12 # wait for response from Stripe API - flaky..
  end

  def enter(field_id, keys)
    page.driver.browser.find_element(:id, field_id).send_keys keys
  end
end

RSpec.configure do |config|
  config.include PayStripeHelper, type: :feature
end
