require_relative '../../lib/parsers/bus_stop_parser'

namespace :sq do
  namespace :buses do
    desc 'Adds all bus stops from BusStopParser'
    task stops: :environment do
      data = BusStopParser.new.data
      DB.transaction do
        data.each do |arr|
          bs = BusStop.new(code: arr[0], name: arr[1])
          bs.latitude, bs.longitude = arr.last
          bs.save
        end
      end
    end
  end
end
