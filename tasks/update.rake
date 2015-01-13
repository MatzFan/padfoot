require File.expand_path(__dir__ + '/../config/boot')

namespace :sq do
  desc "Updates applications in database for given year (defaults to current year)"
  task :update, [:year, :ref] do |t, args|
    args.with_defaults(year: Time.now.year)
    AppRefsScraper.new(args.year).refs.each do |ref|
      scraper = AppDetailsScraper.new(ref)
      PlanningApp.find_or_create(scraper.data_hash) if scraper.has_valid_ref
    end
  end
end
