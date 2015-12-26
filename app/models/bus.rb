class Bus < Sequel::Model

  many_to_one :bus_route, key: :number
  many_to_one :schedule, key: :days
  many_to_many :bus_stops, left_key: :id, right_key: :code

  def before_save
    DB.transaction do
      Schedule.find_or_create(days: self.schedule_days) if self.schedule_days
      BusRoute.find_or_create(number: self.route_number) if self.route_number
    end
    super
  end

end
