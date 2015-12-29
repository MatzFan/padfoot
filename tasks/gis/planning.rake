namespace :sq do
  namespace :gis do
    desc 'Creates and populates tables with scraped data from JerseyPlanning MapServer'
    task :planning, [:index] do |t, args|
      args.with_defaults(index: nil)
      uri = URI.parse DB.url
      conn_hash = {host: uri.host, port: uri.port, dbname: uri.path[1..-1], user: uri.user || `whoami`.chomp, password: uri.password}
      conn_hash.select! { |k, v| v } # don't overide GisScraper defaults will nils :)
      GisScraper.configure conn_hash.merge(srs: 'EPSG:3109')
      range = index ? (args.index.to_i..args.index.to_i) : (2..42) # all except Gazetteer & Landparcels
      (range).each do |i|
        Layer.new("https://gps.digimap.gg/arcgis/rest/services/StatesOfJersey/JerseyPlanning/MapServer/#{i}").output_to_db
      end
    end
  end
end
