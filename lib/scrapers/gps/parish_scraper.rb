require_relative 'gps_scraper'

# scrapes parish data
class ParishScraper < GpsScraper
  URL = 'arcgis/rest/services/StatesOfJersey/JerseyMappingOL/MapServer/6/query'.freeze

  KEYS = %w(OBJECTID FIND_NAME).freeze

  COLUMNS = [:object_id, :parish].freeze

  OBJ_IDS = [[3],[8],[1],[9,15],[17],[11],[4],[12],[6],[10,14],[2,13],[5,7,16]] # maps parish indices to GIS objectids

  def initialize(lower_id = 0, upper_id = 0)
    super
  end

  def process(k, data)
    k == 'FIND_NAME' ? parish_num(data) : data
  end

  def parish_num(s)
    s = (s[0..2] == 'St ' ? s.split(' ').join('. ') : s) # add '.' to 'St'
    num = Parish.select_map(:name).index(s)
    num + 1 if num
  end
end
