namespace :sq do
  namespace :gis do
    desc 'Creates and populates tables for JsySmallBase2 layers'
    task :gaz do
      server = 'http://gis.digimap.je/ArcGIS/rest/services/Gazetteer/MapServer/0'
      GisScraper.configure(dbname: 'jersey', srs: 'EPSG:3109')
      DB.transaction do
        Layer.new(server).output_to_db
      end
    end
  end
end
