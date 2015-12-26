describe BusStopsBus do

  time = Sequel::SQLTime.create(07, 30, 00)
  let(:stop) { build :bus_stop }
  let(:bus) { Bus.new } # PK auto-incremented

  context '#create' do
    it 'can be created with a valid bus id and valid bus_stop code' do
      stop.save # test DB is not pre-populated
      bus_id = bus.save.id
      expect(BusStopsBus.create(bus_id: bus_id, bus_stop_code: '2323', time: time)).not_to be_nil
    end

    it 'can be created with a valid bus id and new bus_stop code' do
      bus_id = bus.save.id
      expect(BusStopsBus.create(bus_id: bus_id, bus_stop_code: '9999', time: time)).not_to be_nil
    end
  end

end
