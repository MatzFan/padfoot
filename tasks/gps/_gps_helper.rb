# configurator for GpsScraper
class GpsHelper
  def self.configure
    conn_hash = { dbname: 'jersey' } # localhost & postgres user
    conn_hash.select! { |_k, v| v } # don't overide defaults with nils :)
    GpsScraper.configure conn_hash.merge(srs: 'EPSG:3109')
  end
end
