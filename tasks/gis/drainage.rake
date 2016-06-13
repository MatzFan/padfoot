require_relative '_gis_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates 21 tables from JerseyUtilities/JerseyUtilities TTS Drainage MapServer layers'
    task :drainage do
      url = 'https://gps.digimap.gg/arcgis/rest/services/JerseyUtilities/JerseyUtilities/MapServer/0'
      GisHelper.configure
      DB.transaction do
        LayerWriter.new(url).output_to_db
      end
    end
  end
end
