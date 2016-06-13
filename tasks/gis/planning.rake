require_relative '_gis_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates tables with data from JerseyPlanning MapServer'
    task :planning, [:index] do |_t, args|
      args.with_defaults(index: nil)
      url = 'http://dcw7.digimap.je/arcgis/rest/services/StatesOfJersey/JerseyPlanning/MapServer/'
      default_range = (2..18).to_a + (20..42).to_a # not Gaz, Landps & Roadcent
      GisHelper.configure
      range = args.index ? (args.index.to_i..args.index.to_i) : default_range
      range.each do |i|
        DB.transaction { LayerWriter.new(url + i).output_to_db }
      end
    end
  end
end
