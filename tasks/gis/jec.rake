require_relative '_gis_helper'

namespace :sq do
  namespace :gis do
    desc 'Creates and populates table from JerseyUtilities/JerseyUtilities JEC MapServer layers'
    task :jec do
      GisHelper.configure
      DB.transaction do
        Layer.new("https://gps.digimap.gg/arcgis/rest/services/JerseyUtilities/JerseyUtilities/MapServer/142").output_to_db
      end
    end
  end
end
