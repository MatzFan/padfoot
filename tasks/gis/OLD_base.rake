require_relative '_gis_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates 7 tables from JerseyMappingOL MapServer layers'
    task :base, [:index] do |_t, args|
      args.with_defaults(index: nil)
      GisHelper.configure
      range = args.index ? (args.index.to_i..args.index.to_i) : (0..6)
      range.each do |i|
        DB.transaction do
          LayerWriter.new("https://gps.digimap.gg/arcgis/rest/services/StatesOfJersey/JerseyMappingOL/MapServer/#{i}").output_to_db
        end
      end
    end
  end
end
