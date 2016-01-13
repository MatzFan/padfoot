namespace :sq do
  namespace :gis do
    desc 'Creates and populates 7 tables from JerseyMappingOL MapServer layers'
    task :base, [:index] do |t, args|
      args.with_defaults(index: nil)
      uri = URI.parse DB.url
      conn_hash = {host: uri.host, port: uri.port, dbname: uri.path[1..-1], user: uri.user || `whoami`.chomp, password: uri.password}
      conn_hash.select! { |k, v| v } # don't overide GisScraper defaults with nils :)
      GisScraper.configure conn_hash.merge(srs: 'EPSG:3109')
      range  = args.index ? (args.index.to_i..args.index.to_i) : (0..6)
      (range).each do |i|
        DB.transaction do
          Layer.new("https://gps.digimap.gg/arcgis/rest/services/StatesOfJersey/JerseyMappingOL/MapServer/#{i}").output_to_db
        end
      end
    end
  end
end
