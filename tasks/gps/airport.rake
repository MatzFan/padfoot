require_relative '_gps_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates 8 tables from JerseyUtilities/JerseyUtilities Airport MapServer layers'
    task :airport do
      GpsHelper.configure
      DB.transaction do
        Layer.new('https://gps.digimap.gg/arcgis/rest/services/JerseyUtilities/JerseyUtilities/MapServer/146').output_to_db
      end
    end
  end
end
