require_relative 'gis_scraper'

class ParishScraper < GisScraper

  URL = 'arcgis/rest/services/StatesOfJersey/JLandOL/MapServer/0/query'

  KEYS = ['OBJECTID', 'FIND_NAME']

  COLUMNS = [:object_id, :parish]

  OBJ_IDS = [[3],[8],[1],[9,15],[17],[11],[4],[12],[6],[10,14],[2,13],[5,7,16]] # maps parish indices to GIS objectids

  def initialize(lower_id = 0, upper_id = 0)
    super
  end

  def process(k, data)
    k == 'FIND_NAME' ? parish_num(data) : data
  end

  def parish_num(s)
    s = (s[0..2] == 'St ' ? s.split(' ').join('. ') : s) # add '.' to 'St'
    num = PARISHES.index(s)
    num + 1 if num
  end

end
