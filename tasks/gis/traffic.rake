require_relative '_gis_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates 3 tables from JerseyUtilities/JerseyUtilities TTS Traffic Signals MapServer layers'
    task :traffic do
      GisHelper.configure
      DB.transaction do
        LayerWriter.new('https://gps.digimap.gg/arcgis/rest/services/JerseyUtilities/JerseyUtilities/MapServer/117').output_to_db
      end
    end
  end
end