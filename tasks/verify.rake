namespace :sq do
  namespace :apps do
    desc "Verifies number of apps in db against Planning site, per year"
    task :verify do
      printf("%s %5s %5s", 'year', 'site', 'dbase') # titles
      Time.now.year.downto(1986) do |year|
        range = Date.new(year,1,1)..Date.new(year,12,31)
        site = PlanningApp.where(valid_date: range).count
        db = AppRefsScraper.new(year).num_apps
        printf("%s %5s %5s", year, site, db) if(site != db)
      end
    end
  end
end
