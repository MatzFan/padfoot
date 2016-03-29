describe GazetteerScraper do
  ID_0 = 'OBJECTID >= 1 AND OBJECTID <= 1'.freeze
  SINGLE_ID_RANGE = 'OBJECTID >= 1092 AND OBJECTID <= 1092'.freeze
  MULTI_ID_RANGE = 'OBJECTID >= 1 AND OBJECTID <= 2'.freeze
  FIELDS = GazetteerScraper.const_get(:FIELD_COLUMN_HASH).keys
  ID_1092 = [{ object_id: 1092,
               guid: 10_879,
               logical_status: 1,
               add1: '25 Pier Road',
               add2: nil,
               add3: nil,
               add4: nil,
               parish_num: 4,
               p_code: 'JE2 4XW',
               island: 'Jersey',
               uprn: 69_003_083,
               usrn: 40_002_299,
               type: 'Commercial',
               address1: '25 PIER ROAD',
               x: 42_035.1,
               y: 65_220.93,
               vingtaine: 'de Haut de la Ville',
               updated: 1_228_953_600_000 }].freeze

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

  context '#attributes' do
    it "returns an array of hashes, each of which has keys: #{FIELDS}" do
      expect(scraper2.attributes.all? { |e| e.keys == FIELDS }).to be true
    end
  end

  context '#data' do
    it "for range (1092, 1092) returns: #{ID_1092}" do
      expect(GazetteerScraper.new(1092, 1092).data).to eq ID_1092
    end
  end
end
