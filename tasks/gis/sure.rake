require_relative '_gis_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates table from JerseyUtilities/JerseyUtilities Sure MapServer layers'
    task :sure do
      GisHelper.configure
      DB.transaction do
        LayerWriter.new('https://gps.digimap.gg/arcgis/rest/services/JerseyUtilities/JerseyUtilities/MapServer/144').output_to_db
      end
    end
  end
end
