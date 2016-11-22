require_relative '_gis_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates 3 tables from JerseyUtilities/JerseyUtilities\
      TTS Traffic Signals MapServer layers'
    task :traffic do
      path = 'JerseyUtilities/JerseyUtilities/MapServer/117'
      LayerWriter.new(SERVER + path).output_to_db
    end
  end
end
