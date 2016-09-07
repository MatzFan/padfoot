describe BusStopParser do
  array_3_d = ['2323', 'Gorey Common S', [49.193795, -2.034982]]
  # gorey_common = { name: 'Gorey Common S',
  #                  code: '2323',
  #                  coords: [49.193795, -2.034982] }

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
      expect(parser.codes.first).to eq '2323'
    end

    it 'converts any non-number to "0"' do
      expect(parser.codes.last).to eq '0' # last is 'St Helier'
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

  context '#data' do
    it 'returns data for 770 bus stops' do
      expect(parser.data.size).to eq 770
    end

    it 'returns 3D array of bus stop data [code, name, [coords]]' do
      expect(parser.data.first).to eq array_3_d
    end
  end
end
