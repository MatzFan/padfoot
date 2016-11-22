require_relative '_gis_helper'

namespace :sq do
  namespace :gis do
    desc 'Creates and populates the buildings table'
    task :base, [:index] do |_t, args|
      args.with_defaults(index: nil)
      range = args.index ? (args.index.to_i..args.index.to_i) : (1..6) # Gaz 0
      range.each do |n|
        LayerWriter.new(SERVER + 'JerseyMappingOL/MapServer/' + n).output_to_db
      end
    end
  end
end
