require_relative '_gis_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates 4 tables from JerseyUtilities/JerseyUtilities Jersey Water MapServer layers'
    task :water do
      GisHelper.configure
      DB.transaction do
        LayerWriter.new('https://gps.digimap.gg/arcgis/rest/services/JerseyUtilities/JerseyUtilities/MapServer/124').output_to_db
      end
    end
  end
end
