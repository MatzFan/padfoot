require_relative '_gis_helper'

namespace :sq do
  namespace :gis do
    desc 'Creates and populates tables with scraped data from JerseyPlanning MapServer'
    task :planning, [:index] do |t, args|
      args.with_defaults(index: nil)
      GisHelper.configure
      range = args.index ? (args.index.to_i..args.index.to_i) : (2..18).to_a + (20..42).to_a # all except Gazetteer, Landparcels & Roadcentrelines
      (range).each do |i|
        DB.transaction do
          Layer.new("https://gps.digimap.gg/arcgis/rest/services/StatesOfJersey/JerseyPlanning/MapServer/#{i}").output_to_db
        end
      end
    end
  end
end
