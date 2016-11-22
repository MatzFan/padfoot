require_relative '_gis_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates table from JerseyUtilities/JerseyUtilities\
      Sure MapServer layers'
    task :sure do
      path = 'JerseyUtilities/JerseyUtilities/MapServer/144'
      LayerWriter.new(SERVER + path).output_to_db
    end
  end
end
