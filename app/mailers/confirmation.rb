Padfoot::App.mailer :confirmation do
  port = Padrino::Application.settings.port
  CONF_URL = 'http://' + (ENV['DOMAIN'] || "0.0.0.0:#{port}") + '/confirm'

  email :confirmation_email do |name, email, id, link|
    from 'jerseypropertyservices.com'
    subject "Please confirm your account"
    to email
    locals name: name, confirmation_link: "#{CONF_URL}/#{id}/#{link}"
    render :'confirmation/confirmation_email'
  end
end
