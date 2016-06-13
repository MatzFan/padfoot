# require_relative '_gis_helper'

# namespace :sq do
#   namespace :gis do
#     desc 'Creates and populates tables for JsySmallBase2 layers'
#     task :smallbase, [:index] do |_t, args|
#       args.with_defaults(index: nil)
#       server = 'http://gis.digimap.je/ArcGIS/rest/services/JsySmallBase2/MapServer/'
#       GisHelper.configure
#       range = args.index ? (args.index.to_i..args.index.to_i) : (0..6)
#       range.each do |n|
#         DB.transaction do
#           LayerWriter.new("#{server}#{n}").output_to_db
#         end
#       end
#     end
#   end
# end
