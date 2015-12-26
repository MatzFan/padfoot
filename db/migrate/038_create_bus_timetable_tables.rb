Sequel.migration do
  change do

    create_table :bus_routes do
      String :number, primary_key: true
    end

    create_table :schedules do
      String :days, primary_key: true
    end

    create_table :buses do
      primary_key :id
      String :bound
      foreign_key :route_number, :bus_routes, type: String
      foreign_key :schedule_days, :schedules, type: String
    end

    create_table :bus_stops_buses do # alphabetical & plural
      foreign_key :bus_stop_code, :bus_stops, type: String
      foreign_key :bus_id, :buses
      Time :time, only_time: true # use Sequel::SQLTime.create(hh, mm, ss) to create
      primary_key [:bus_stop_code, :bus_id]
      index [:bus_stop_code, :bus_id]
    end

  end
end
