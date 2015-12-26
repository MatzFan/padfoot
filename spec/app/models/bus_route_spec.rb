describe BusRoute do

  let(:route) { BusRoute.create(number: '1g') }

  it 'can be created' do
    expect(route).not_to be_nil
  end

end
