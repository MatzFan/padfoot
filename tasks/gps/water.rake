require_relative '_gps_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates 4 tables from JerseyUtilities/JerseyUtilities Jersey Water MapServer layers'
    task :water do
      GpsHelper.configure
      DB.transaction do
        Layer.new('https://gps.digimap.gg/arcgis/rest/services/JerseyUtilities/JerseyUtilities/MapServer/124').output_to_db
      end
    end
  end
end
