require_relative '_gis_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates 7 tables from JerseyMappingOL MapServer layers'
    task :base, [:index] do |_t, args|
      args.with_defaults(index: nil)
      path = 'StatesOfJersey/JerseyMappingOL/MapServer/'
      GisHelper.configure
      range = args.index ? (args.index.to_i..args.index.to_i) : (0..6)
      range.each do |i|
        LayerWriter.new("#{SERVER}#{path}#{i}").output_to_db
      end
    end
  end
end
