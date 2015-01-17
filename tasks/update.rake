require File.expand_path(__dir__ + '/../config/boot')

namespace :sq do
  desc "Update applications in database for given year (default: current year)"
  task :update, [:year, :ref] do |t, args|
    args.with_defaults(year: Time.now.year)
    refs = AppRefsScraper.new(args.year).refs
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
