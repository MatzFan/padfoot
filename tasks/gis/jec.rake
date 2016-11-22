require_relative '_gis_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates table from JerseyUtilities/JerseyUtilities\
      JEC MapServer layers'
    task :jec do
      path = 'JerseyUtilities/JerseyUtilities/MapServer/142'
      LayerWriter.new(SERVER + path).output_to_db
    end
  end
end
