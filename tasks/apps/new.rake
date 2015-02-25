namespace :sq do
  namespace :apps do
    desc "Get new applications for given year (default: current year) and from a given start page (default: 1)"
    task :new, [:year, :start_page] do |t, args|
      args.with_defaults(year: Time.now.year, start_page: 1)
      scraped = AppRefsScraper.new(args.year, args.start_page).refs
      in_db = PlanningApp.where(app_ref: scraped).select_map(:app_ref)
      # begin
        app_data = AppDetailsScraper.new(scraped - in_db).data # filter first
      # rescue PageStructureChanged
      # end
      DB.transaction do # transaction more efficient
        app_data.each { |hash| PlanningApp.create(hash) }
      end unless app_data.empty?
    end
  end
end
