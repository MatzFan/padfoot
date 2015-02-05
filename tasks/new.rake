namespace :sq do
  namespace :apps do
    desc "Get new applications for given year (default: current year) and from a given start page (default: 1)"
    task :new, [:year, :start_page] do |t, args|
      args.with_defaults(year: Time.now.year, start_page: 1)
      refs = AppRefsScraper.new(args.year, args.start_page).refs
      AppDetailsScraper.new(refs).data_hash_arr.each do |hash| # each a tranc
        PlanningApp.create(hash) if !PlanningApp.find(app_ref: hash[:app_ref])
      end
    end
  end
end
