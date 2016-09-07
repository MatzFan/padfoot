# require_relative '../../lib/scrapers/bus_timetable_scraper'

# namespace :sq do
#   namespace :buses do
#     desc 'Adds all bus stops from BusStopParser'
#     task times: :environment do
#       s = BusTimetableScraper.new
#       # (0...s.num_routes).each do |route_index|
#       (19...20).each do |route_index|
#         s.buses(route_index).each do |route_buses| #
#           route_buses.each do |bus_data|
#             n, bound, days, stop_times = *bus_data
#             DB.transaction do
#               b = Bus.create(route_number: n, bound: bound, schedule_days: days)
#               stop_times.each do |code_time|
#                 code, t = *code_time
#                 BusStopsBus.create(bus_id: b.id, bus_stop_code: code, time: t)
#               end
#             end
#           end
#         end
#       end
#     end
#   end
# end
