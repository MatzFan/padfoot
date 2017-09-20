require_relative 'digimap_scraper'

# class to scrape gazetteer
class GazetteerScraper < DigimapScraper
  URL = 'StatesOfJersey/JerseyMappingOL/MapServer/0'.freeze
  FORM_FIELDS = %w[f where outFields].freeze
  FORM_RADIOS = %w[returnCountOnly].freeze
  FIELD_COLUMN_HASH = { 'OBJECTID' => :object_id,
                        'guid_' => :guid,
                        'Add1' => :add1,
                        'Add2' => :add2,
                        'Add3' => :add3,
                        'Add4' => :add4,
                        'Parish' => :parish_num,
                        'Postcode' => :p_code,
                        'Island' => :island_name,
                        'UPRN' => :uprn,
                        'USRN' => :usrn,
                        'Address1' => :address1,
                        'Easting' => :x,
                        'Northing' => :y,
                        'Vingtaine' => :vingtaine,
                        'Updated' => :updated,
                        'logicalstatus' => :logical_status,
                        'Property_Type' => :type }.freeze
  PARISHES = { 'Grouville' => 1,
               'St. Brelade' => 2,
               'St. Clement' => 3,
               'St. Helier' => 4,
               'St. John' => 5,
               'St. Lawrence' => 6,
               'St. Martin' => 7,
               'St. Mary' => 8,
               'St. Ouen' => 9,
               'St. Peter' => 10,
               'St. Saviour' => 11,
               'Trinity' => 12 }.freeze

  def initialize(min = 1, max = 1, validate_fields: true)
    super
  end

  def process(hash)
    super # replaces ''s with nils
    hash[:parish_num] = PARISHES[hash[:parish_num]]
    hash[:updated] = Time.at(hash[:updated] / 1000)
    hash
  end
end
