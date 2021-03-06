require_relative '_gis_helper'

namespace :sq do
  namespace :gis do
    desc 'Creates and populates 21 tables from JerseyUtilities/JerseyUtilities\
      TTS Drainage MapServer layers'
    task :drainage do
      path = 'JerseyUtilities/JerseyUtilities/MapServer/0'
      LayerWriter.new(SERVER + path).output_to_db
    end
  end
end
