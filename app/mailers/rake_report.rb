Padfoot::App.mailer :rake_report do

  email :daily_report_email do |report|
    from 'jerseypropertyservices.com'
    subject 'Daily report'
    to 'jerseypropertyservices@gmail.com'
    locals report: report
    render 'reports/rake_report'
  end

end
