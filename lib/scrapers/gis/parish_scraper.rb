class ParishScraper < GisScraper

  URL = 'arcgis/rest/services/StatesOfJersey/JLandOL/MapServer/0/query'

  KEYS = ['OBJECTID', 'FIND_NAME']

  COLUMNS = [:object_id, :name]

  def initialize(lower_id = 0, upper_id = 0)
    super
  end

end
