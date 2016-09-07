require 'gis_scraper'

SERVER = 'https://gps.digimap.gg/arcgis/rest/services/'.freeze

# configurator for GpsScraper
class GisHelper
  def self.configure
    GisScraper.configure(dbname: 'jersey', srs: 'EPSG:3109')
  end
end
