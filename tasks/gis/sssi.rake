require_relative '_gis_helper'

namespace :sq do
  namespace :gis do
    desc 'Creates and populates tables for SSSI layer'
    task :sssi do
      url = 'http://gis.digimap.je/ArcGIS/rest/services/JsyBoreholes/MapServer/4'
      GisHelper.configure
      DB.transaction do
        LayerWriter.new(url).output_to_db
      end
    end
  end
end
