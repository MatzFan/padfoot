require_relative '_gis_helper'

namespace :sq do
  namespace :gis do
    desc 'Creates and populates 6 tables from JerseyUtilities/JerseyUtilities\
      Jersey Gas MapServer layers'
    task :gas do
      path = 'JerseyUtilities/JerseyUtilities/MapServer/129'
      LayerWriter.new(SERVER + path).output_to_db
    end
  end
end
