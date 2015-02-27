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
  tasks = ['sq:apps:docs', 'sq:apps:changes', 'sq:apps:new']
  desc "Runs listed rake tasks & emails an output report: #{tasks.join(', ')}"
  task update: :environment do
    t = Time.now
    exit if Date.today.wday < 2 # runs Tuesday thru Saturday
    report = tasks.map { |task| capture_stdout { Rake::Task[task].invoke } }
    report << "Completed in #{(Time.now - t).to_i/60} minutes"
    Padfoot::App.deliver(:rake_report, :daily_report_email, report)
  end
end
