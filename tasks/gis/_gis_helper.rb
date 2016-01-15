class GisHelper

  def self.configure
    uri = URI.parse DB.url
    conn_hash = {host: uri.host, port: uri.port, dbname: uri.path[1..-1], user: uri.user || `whoami`.chomp, password: uri.password}
    conn_hash.select! { |k, v| v } # don't overide GisScraper defaults with nils :)
    GisScraper.configure conn_hash.merge(srs: 'EPSG:3109')
  end

end
