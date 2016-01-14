def capture_stdout
  begin
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end
end

namespace :sq do
  tasks = ['sq:apps:changes', 'sq:apps:new'] # omit docs until fixed
  # , 'sq:apps:docs']
  desc "Runs listed rake tasks & emails an output report: #{tasks.join(', ')}"
  task update: :environment do
    exit if Date.today.wday < 2 # runs Tuesday thru Saturday
    sleep 3600 if !Time.now.dst? # Heroku Scheduler runs on UTC
    t = Time.now
    report = tasks.map { |task| capture_stdout { Rake::Task[task].invoke } }
    if report.include? 'ERROR'
      Padfoot::App.deliver(:rake_error_report, :daily_report_email, report)
    else
      report << "Completed in #{(Time.now - t).to_i/60} minutes"
      Padfoot::App.deliver(:rake_success_report, :daily_report_email, report)
    end
  end
end
