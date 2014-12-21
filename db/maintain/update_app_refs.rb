require_relative 'maintenance_helper'

refs = AppRefsScraper.new(2014, '2174').latest_refs. each do |ref|
  scraper = AppDetailsScraper.new(ref)
  app_data = scraper.app_data if scraper.has_valid_ref
  # Application.find_or_create()
end
