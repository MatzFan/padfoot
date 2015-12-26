describe Bus do

  let(:bus) { Bus.create(route_number: '1g', schedule_days: 'Monday-Friday') }

  context '#create' do
    it 'can be created' do
      expect(bus).not_to be_nil
    end
  end

end
