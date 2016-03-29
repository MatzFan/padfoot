require_relative '_gps_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates table from JerseyUtilities/JerseyUtilities JT MapServer layers'
    task :jt do
      GpsHelper.configure
      DB.transaction do
        Layer.new('https://gps.digimap.gg/arcgis/rest/services/JerseyUtilities/JerseyUtilities/MapServer/139').output_to_db
      end
    end
  end
end
