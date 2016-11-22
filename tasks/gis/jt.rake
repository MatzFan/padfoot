require_relative '_gis_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates table from JerseyUtilities/JerseyUtilities\
      JT MapServer layers'
    task :jt do
      path = 'JerseyUtilities/JerseyUtilities/MapServer/139'
      LayerWriter.new(SERVER + path).output_to_db
    end
  end
end
