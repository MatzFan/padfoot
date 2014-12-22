require_relative 'maintenance_helper'

refs = AppRefsScraper.new(2014, '2199').latest_refs.each do |ref|
  scraper = AppDetailsScraper.new(ref)
  Application.find_or_create(scraper.data_hash) if scraper.has_valid_ref
end
