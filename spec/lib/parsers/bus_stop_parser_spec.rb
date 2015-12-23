describe BusStopParser do

  hash = {name: 'Gorey Common S', code: '02323', coords: [49.193795, -2.034982]}
  let(:parser) { BusStopParser.new }

  context '#new' do
    it 'returns an instance of the class' do
      expect(parser.class).to eq(BusStopParser)
    end
  end

  context '#json' do
    it 'returns a 4 element Array of the json bus stop data' do
      expect(parser.json.size).to eq 4
    end
  end

  context '#places' do
    it 'returns raw data for all 771 bus stops' do
      expect(parser.places.size).to eq 771
    end
  end

  context '#codes' do
    it 'returns array of bus stop codes' do
      expect(parser.codes.first).to eq '02323'
    end
  end
  context '#names' do
    it 'returns array of bus stop names' do
      expect(parser.names.first).to eq 'Gorey Common S'
    end
  end

  context '#coords' do
    it 'returns array of bus stop coords' do
      expect(parser.coords.first).to eq [49.193795, -2.034982]
    end
  end

end
