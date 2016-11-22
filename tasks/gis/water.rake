require_relative '_gis_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates 4 tables from JerseyUtilities/JerseyUtilities\
      Jersey Water MapServer layers'
    task :water do
      path = 'JerseyUtilities/JerseyUtilities/MapServer/124'
      LayerWriter.new(SERVER + path).output_to_db
    end
  end
end
