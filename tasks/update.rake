namespace :sq do
  tasks = ['sq:apps:docs', 'sq:apps:changes', 'sq:apps:new']
  desc "Runs the following rake tasks daily: #{tasks.join(', ')}"
  task :update do
    exit if Date.today.wday < 2 # runs Tuesday thru Saturday
    tasks.each { |task| Rake::Task[task].invoke }
  end
end
