require_relative '_gis_helper'

namespace :sq do
  namespace :gis do
    desc 'Creates and populates tables for SSSI layer'
    task :sssi do
      path = 'JsyBoreholes/MapServer/4'
      LayerWriter.new(SERVER + path).output_to_db
    end
  end
end
