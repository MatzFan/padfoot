require_relative '../../lib/scrapers/digimap/gazetteer_scraper'

namespace :sq do
  namespace :props do
    desc 'Populates properties table from Digimap Gazetteer layer'
    task all: :environment do
      data = GazetteerScraper.new.all_data
      us = data.map { |e| e[:uprn] }
      DB.transaction do # update or create each
        data.map do |h|
          (p = Property[h[:uprn]]) ? p.update(h) : Property.create(h)
        end
      end
      DB.transaction do # mark missing properties as not current
        Property.map { |p| p.update(current: false) unless us.include? p.uprn }
      end
    end
  end
end
