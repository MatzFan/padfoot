class BusStopsBus < Sequel::Model

  unrestrict_primary_key

  def before_save
    DB.transaction do
      BusStop.find_or_create(code: self.bus_stop_code) if self.bus_stop_code
    end
    super
  end

end
