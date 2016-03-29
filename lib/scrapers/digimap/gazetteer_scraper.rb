require_relative 'digimap_scraper'

# class to scrape gazetteer
class GazetteerScraper < DigimapScraper
  URL = 'Gazetteer2/MapServer/0/query'.freeze
  KEYS = %w(OBJECTID guid_ logicalstatus Add1 Add2 Add3 Add4 Parish Postcode
            Island UPRN USRN Property_Type Address1 Easting Northing Vingtaine
            Updated).freeze

  def initialize(min = 1, max = 1)
    super
  end
end
