require_relative '_gis_helper'

namespace :sq do
  namespace :gis do
    desc 'Creates and populates tables for Gazetteer layer'
    task :gaz do
      path = 'JSearch/MapServer/2'
      LayerWriter.new(SERVER + path).output_to_db
    end
  end
end
