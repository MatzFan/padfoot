require_relative '_gis_helper'

namespace :sq do
  namespace :gis do
    desc 'Creates and populates 22 tables from JerseyUtilities/JerseyUtilities TTS Drainage MapServer layers'
    task :drainage do
      GisHelper.configure
      DB.transaction do
        Layer.new("https://gps.digimap.gg/arcgis/rest/services/JerseyUtilities/JerseyUtilities/MapServer/0").output_to_db
      end
    end
  end
end
