namespace :sq do
  namespace :apps do
    desc "Get new applications for given year (default: current year) and from a given start page (default: 1)"
    task :new, [:year, :start_page] do |t, args|
      args.with_defaults(year: Time.now.year, start_page: 1)
      refs = AppRefsScraper.new(args.year, args.start_page).refs
      bar = RakeProgressbar.new(refs.count)
      refs.each do |ref|
        s = AppDetailsScraper.new(ref)
        if s.has_valid_ref
          app_ref = s.data_hash[:app_ref]
          PlanningApp.create(s.data_hash) if !PlanningApp.find(app_ref: app_ref)
        end
        bar.inc
      end
      bar.finished
    end
  end
end
