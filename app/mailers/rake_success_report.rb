Padfoot::App.mailer :rake_success_report do
  email :daily_report_email do |report|
    from 'jerseypropertyservices.com'
    to 'jerseypropertyservices@gmail.com'
    subject 'Daily report'
    locals report: report
    render 'reports/rake_report'
  end
end
