require_relative '_gps_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates 21 tables from JerseyUtilities/JerseyUtilities TTS Drainage MapServer layers'
    task :drainage do
      GpsHelper.configure
      DB.transaction do
        Layer.new('https://gps.digimap.gg/arcgis/rest/services/JerseyUtilities/JerseyUtilities/MapServer/0').output_to_db
      end
    end
  end
end
