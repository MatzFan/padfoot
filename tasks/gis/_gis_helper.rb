# configurator for GpsScraper
class GisHelper
  def self.configure
    GisScraper.configure(dbname: 'jersey', srs: 'EPSG:3109')
  end
end
