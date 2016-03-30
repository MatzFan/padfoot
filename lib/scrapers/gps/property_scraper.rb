require_relative 'gps_scraper'

# scrapes property data
class PropertyScraper < GpsScraper
  URL = 'arcgis/rest/services/StatesOfJersey/JerseyPlanning/MapServer/0/query'.freeze

  KEYS = %w(OBJECTID guid_ Add1 Add2 Add3 Add4 Parish Postcode UPRN USRN
            Property_Type Address1 Vingtaine).freeze

  COLUMNS = [:object_id, :guid, :add1, :add2, :add3, :add4, :parish_num,
             :p_code, :uprn, :usrn, :type, :address1, :vingtaine].freeze

  def initialize(lower_id = 0, upper_id = 0)
    super
  end

  def process(k, d) # data may be String or Fixnum
    return d if d.is_a? Numeric
    return parish_num(d) if k == 'Parish'
    d.strip.empty? ? nil : d.strip
  end

  def parish_num(s)
    num = Parish.select_map(:name).index(s.downcase.split(' ').map(&:capitalize).join(' '))
    num + 1 if num
  end
end
