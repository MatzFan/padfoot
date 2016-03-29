require_relative '_gps_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates 3 tables from JerseyUtilities/JerseyUtilities TTS Traffic Signals MapServer layers'
    task :traffic do
      GpsHelper.configure
      DB.transaction do
        Layer.new('https://gps.digimap.gg/arcgis/rest/services/JerseyUtilities/JerseyUtilities/MapServer/117').output_to_db
      end
    end
  end
end
