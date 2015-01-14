Padfoot::App.mailer :confirmation do
  CONFIRMATION_URL = "http://#{ENV['DOMAIN'] || '0.0.0.0:9292'}/confirm"

  email :confirmation_email do |name, email, id, link|
    from 'jerseypropertyservices.com'
    subject "Please confirm your account"
    to email
    locals name: name, confirmation_link: "#{CONFIRMATION_URL}/#{id}/#{link}"
    render :'confirmation/confirmation_email'
  end
end
