namespace :sq do
  namespace :buses do
    desc "Adds all bus stops from BusStopParser"
    task :times do
      s = BusTimetableScraper.new
      # (0...s.num_routes).each do |route_index|
      (19...20).each do |route_index|
        s.buses(route_index).each do |route_buses| #
          route_buses.each do |bus_data|
            num, bound, days, stop_times = *bus_data
            DB.transaction do
              bus = Bus.create(route_number: num, bound: bound, schedule_days: days)
              stop_times.each do |code_time|
                code, time = *code_time
                BusStopsBus.create(bus_id: bus.id, bus_stop_code: code, time: time)
              end
            end
          end
        end
      end
    end
  end
end
