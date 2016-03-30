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
                        'Island' => :island_name,
                        'UPRN' => :uprn,
                        'USRN' => :usrn,
                        'Property_Type' => :type,
                        'Address1' => :address1,
                        'Easting' => :x,
                        'Northing' => :y,
                        'Vingtaine' => :vingtaine,
                        'Updated' => :updated }.freeze

  def initialize(min = 1, max = 1)
    super
  end

  def process(hash)
    super # replaces ''s with nils
    hash[:parish_num] = Parish.to_hash(:name, :number)[hash[:parish_num]]
    hash[:updated] = Time.at(hash[:updated] / 1000)
    hash
  end
end
