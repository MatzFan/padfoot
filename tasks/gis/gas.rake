require_relative '_gis_helper'

namespace :sq do
  namespace :gis do
    desc 'Creates and populates 6 tables from JerseyUtilities/JerseyUtilities Jersey Gas MapServer layers'
    task :gas do
      GisHelper.configure
      DB.transaction do
        Layer.new("https://gps.digimap.gg/arcgis/rest/services/JerseyUtilities/JerseyUtilities/MapServer/129").output_to_db
      end
    end
  end
end
