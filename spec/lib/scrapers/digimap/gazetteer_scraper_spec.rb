describe GazetteerScraper do
  ID_0 = 'OBJECTID >= 1 AND OBJECTID <= 1'.freeze
  SINGLE_ID_RANGE = 'OBJECTID >= 1092 AND OBJECTID <= 1092'.freeze
  MULTI_ID_RANGE = 'OBJECTID >= 1 AND OBJECTID <= 2'.freeze
  ATT_KEYS = GazetteerScraper.const_get :KEYS
  ID_1092 = [{ x: 42_035.15699999966,
               y: 65_219.985874999315,
               object_id: 29_727,
               guid: 10_593,
               add1: '25 Pier Road',
               add2: nil,
               add3: nil,
               add4: nil,
               parish_num: 4,
               p_code: 'JE2 4XW',
               uprn: 69_003_083,
               usrn: 40_002_299,
               type: 'Commercial',
               address1: '25 PIER ROAD,',
               vingtaine: 'de Haut de la Ville' }].freeze

  let(:scraper) { GazetteerScraper.new }
  let(:scraper2) { GazetteerScraper.new(1, 2) }

  context '#new(min, max)' do
    it 'can be instantiated with no args' do
      expect(GazetteerScraper.new.class).to eq GazetteerScraper
    end

    it 'can be instantiated with min and max (OBJECTID) args' do
      expect(scraper2.class).to eq GazetteerScraper
    end

    it 'raises ArgumentError of min > max' do
      expect(-> { GazetteerScraper.new(2, 1) }).to raise_error ArgumentError
    end

    it 'raises ArgumentError of min < 1' do
      expect(-> { GazetteerScraper.new(0, 1) }).to raise_error ArgumentError
    end
  end

  context '#form' do
    it 'returns a Mechanize::Form object' do
      expect(scraper.form.class).to eq Mechanize::Form
    end
  end

  context '#range' do
    it "returns #{ID_0} for a scraper instantiated without params" do
      expect(GazetteerScraper.new.range).to eq ID_0
    end

    it "returns #{MULTI_ID_RANGE} for a scraper instantiated with (0, 1000)" do
      expect(scraper2.range).to eq MULTI_ID_RANGE
    end
  end

  context '#num_records' do
    it 'returns the total number of properties (> 60,000)' do
      expect(scraper.num_records).to be > 60_000
    end
  end

  context '#json' do
    it 'returns a Hash with key "features"' do
      expect(scraper.json.keys).to include 'features'
    end
  end

  context '#features' do
    it 'returns array whose size matches the scraper range' do
      expect(scraper2.features.size).to eq 2
    end
  end

  context '#geometry' do
    it 'returns an array of hashes, each of which has keys "x" and "y"' do
      expect(scraper2.geometry.all? { |e| e.keys == %w(x y) }).to be true
    end
  end

  context '#attributes' do
    it "returns an array of hashes, each of which has keys #{ATT_KEYS}" do
      expect(scraper2.attributes.all? { |e| e.keys == ATT_KEYS }).to be true
    end
  end

  # xcontext '#data(query_string)' do
  #   it 'returns 1,000 records with "OBJECTID > 0 AND OBJECTID < 1,001"' do
  #     expect(scraper.data('OBJECTID > 0 AND OBJECTID < 1001')).to be > 1_000
  #   end
  # end
end
