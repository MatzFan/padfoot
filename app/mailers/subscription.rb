Padfoot::App.mailer :subscription do
  email :subscription_email do |name, email|
    from 'jerseypropertyservices@gmail.com'
    to email
    subject 'Welcome to jerseypropertyservices.com!'
    locals name: name # defines variables in scope for the email template
    render :'subscription/subscription_email' # where msg body is defined
    # add_file filename: 'invoice.pdf', content:
    #   File.open("#{Padrino.root}/app/assets/pdf/welcome.pdf") { |f| f.read }
    content_type :plain
  end
end
