require_relative '_gis_helper'

namespace :sq do
  namespace :gis do
    desc 'Creates and populates the buildings table'
    task :base, [:index] do |_t, args|
      args.with_defaults(index: nil)
      url = 'http://gis.digimap.je/ArcGIS/rest/services/JsyBase/MapServer/'
      GisHelper.configure
      range = args.index ? (args.index.to_i..args.index.to_i) : (32..40)
      range.each do |n|
        DB.transaction { LayerWriter.new(url + n).output_to_db }
      end
    end
  end
end
