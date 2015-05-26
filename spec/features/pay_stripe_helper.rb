module PayStripeHelper # credit here: https://gist.github.com/nruth/b2500074749e9f56e0b7

  FIELD_IDS = ['email', 'card_number', 'cc-exp', 'cc-csc']
  # keys must be same as FIELD_IDS
  CHECKOUT_DEFAULTS = { :email => 'test@example.com',
                        :card_number => '4242424242424242',
                        :'cc-exp' => '1218', # month & year
                        :'cc-csc' => '123'
                      }

  def enable_stripe_event_capture
    port, dn = Padrino::Application.settings.port, '/dev/null'
    pid = spawn("ultrahook stripe #{port}/stripe_events", out: dn, err: dn)
    Process.detach pid
    pid # return pid
  end

  def click_checkout_button
    create(:user, confirmation: true)
    visit "/users/#{User.first.id}/subscribe"
    click_button 'Pay with Card'
    sleep 1
  end

  def checkout(opts = {})
    opts = CHECKOUT_DEFAULTS.merge opts
    within_frame 'stripe_checkout_app' do
      FIELD_IDS.each { |id| enter(id, opts[id.to_sym]) }
      find('button[type="submit"]').click
    end
    sleep 10
  end

  def enter(field_id, keys)
    page.driver.browser.find_element(:id, field_id).send_keys keys
  end

end

RSpec.configure do |config|
  config.include PayStripeHelper, type: :feature
end
