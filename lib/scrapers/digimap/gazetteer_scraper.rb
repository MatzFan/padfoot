require_relative 'digimap_scraper'

# class to scrape gazetteer
class GazetteerScraper < DigimapScraper
  URL = 'Gazetteer2/MapServer/0'.freeze
  FIELD_COLUMN_HASH = { 'OBJECTID' => :object_id,
                        'guid_' => :guid,
                        'logicalstatus' => :logical_status,
                        'Add1' => :add1,
                        'Add2' => :add2,
                        'Add3' => :add3,
                        'Add4' => :add4,
                        'Parish' => :parish_num,
                        'Postcode' => :p_code,
                        'Island' => :island,
                        'UPRN' => :uprn,
                        'USRN' => :usrn,
                        'Property_Type' => :type,
                        'Address1' => :address1,
                        'Easting' => :x,
                        'Northing' => :y,
                        'Vingtaine' => :vingtaine,
                        'Updated' => :updated }.freeze

  PARISH_HASH = Parish.to_hash(:name, :number)

  def initialize(min = 1, max = 1)
    super
  end

  def process(hash)
    super # replaces ''s with nils
    hash.merge(parish_num: PARISH_HASH[hash[:parish_num]])
  end
end
