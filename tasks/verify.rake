namespace :sq do
  namespace :apps do
    desc "Verifies number of apps in db against Planning site, per year"
    task :verify do
      years = 2015.downto 2014
      results = years.map do |year|
        range = Date.new(year,1,1)..Date.new(year,12,31)
        [year, PlanningApp.where(valid_date: range).count, AppRefsScraper.new(year).num_apps]
      end
      results.each { |arr| puts "#{arr[0]} site:db   #{arr[1]}:#{arr[2]}" }
    end
  end
end
