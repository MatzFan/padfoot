require_relative '_gps_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates tables with scraped data from JerseyPlanning MapServer'
    task :planning, [:index] do |_t, args|
      args.with_defaults(index: nil)
      GpsHelper.configure
      # all except Gazetteer, Landparcels & Roadcentrelines
      range = args.index ? (args.index.to_i..args.index.to_i) : (2..18).to_a + (20..42).to_a
      range.each do |i|
        DB.transaction do
          Layer.new("https://gps.digimap.gg/arcgis/rest/services/StatesOfJersey/JerseyPlanning/MapServer/#{i}").output_to_db
        end
      end
    end
  end
end
