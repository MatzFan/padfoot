require File.expand_path(__dir__ + '/../../lib/scrapers/app_refs_scraper')

AppRefsScraper.new(2014, '2174').latest_refs.each do |ref|
  puts ref
end
