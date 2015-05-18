require_relative 'gis_scraper'

class PropertyScraper < GisScraper

  URL = 'arcgis/rest/services/StatesOfJersey/JerseyPlanning/MapServer/0/query'

  KEYS = ['OBJECTID', 'guid_', 'Add1', 'Add2', 'Add3', 'Add4', 'Parish',
          'Postcode', 'UPRN', 'USRN', 'Property_Type', 'Address1', 'Vingtaine']

  COLUMNS = [:object_id, :guid, :add1, :add2, :add3, :add4, :parish_num,
          :p_code, :uprn, :usrn, :type, :address1, :vingtaine]

  def initialize(lower_id = 0, upper_id = 0)
    super
  end

  def process(k, d) # data may be String or Fixnum
    return d if d.kind_of? Numeric
    return parish_num(d) if k == 'Parish'
    d.strip.empty? ? nil : d.strip
  end

  def parish_num(s)
    num = PARISHES.index(s.downcase.split(' ').map(&:capitalize).join(' '))
    num + 1 if num
  end

end
