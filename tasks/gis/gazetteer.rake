require_relative '_gis_helper'

namespace :sq do
  namespace :gis do
    desc 'Creates and populates tables for JsySmallBase2 layers'
    task :gaz do
      server = 'http://gis.digimap.je/ArcGIS/rest/services/Gazetteer/MapServer/0'
      GisHelper.configure
      DB.transaction do
        LayerWriter.new(server).output_to_db
      end
    end
  end
end
