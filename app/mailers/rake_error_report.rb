Padfoot::App.mailer :rake_error_report do

  email :daily_report_email do |report|
    from 'jerseypropertyservices.com'
    subject 'ERROR report'
    to 'bruce.steedman@gmail.com'
    locals report: report
    render 'reports/rake_report'
  end

end
