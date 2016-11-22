require_relative '_gis_helper'

namespace :sq do
  namespace :gis do
    desc 'Creates and populates 8 tables from JerseyUtilities/JerseyUtilities\
      Airport MapServer layers'
    task :airport do
      path = 'JerseyUtilities/JerseyUtilities/MapServer/146'
      LayerWriter.new(SERVER + path).output_to_db
    end
  end
end
