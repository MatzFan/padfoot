require File.expand_path(__dir__ + '/../config/boot')

namespace :sq do
  desc "Updates applications in database for given year & ref (defaults to current year & '0000')"
  task :update, [:year, :ref] do |t, args|
    args.with_defaults(year: Time.now.year, ref: '0000')
    AppRefsScraper.new(args.year, args.ref).latest_refs.each do |ref|
      scraper = AppDetailsScraper.new(ref)
      Application.find_or_create(scraper.data_hash) if scraper.has_valid_ref
    end
  end
end
