require_relative '_gis_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates table from JerseyUtilities/JerseyUtilities JT MapServer layers'
    task :jt do
      GisHelper.configure
      DB.transaction do
        LayerWriter.new('https://gps.digimap.gg/arcgis/rest/services/JerseyUtilities/JerseyUtilities/MapServer/139').output_to_db
      end
    end
  end
end