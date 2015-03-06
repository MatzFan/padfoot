describe PropertyScraper do

  UPRNS = [69213704, 69213730, 69213735, 69115918, 69115917, 69115921,
           69200044, 69213705, 69213728, 69213733, 69213895, 69300127,
           69115919, 69213907, 69214092, 69115916, 69200001, 69213732,
           69360012, 69213729, 69213736, 69213737, 69213906, 69402083,
           69150001, 69213731, 69213734, 69385980, 69115920, 69213702,
           69213884, 69213951, 69387750]

  LENORD = [69115918, ["Le Nord<br/>La Rue de Crabbe<br/>St. Mary<br/>JE3 3AD",
             'La Rue de Crabbe', 8, 'JE3 3AD']]
  FOURNEAUX = [69407485, ['Fourneaux<br/>Le Clos Du Hambye<br/>La Route de la'+
                ' Hougue Bie<br/>St. Saviour<br/>JE2 7BS', 'La Route de la'+
                ' Hougue Bie', 11, 'JE2 7BS']]

  ALL_ROADS = ['La Rue de la Corbiere', 'La Route de la Hougue Bie']

  string = 'crabbe'
  parish_num = 2
  string_scraper = PropertyScraper.new(string)
  fourneaux = PropertyScraper.new('fourneaux') # captures St. Brelade and St. Saviour
  parish_scraper = PropertyScraper.new('fourneaux', 11) # 11 is St. Saviour

  context '#new' do
    it 'returns an instance of the class with no parish number supplied' do
      expect(string_scraper.class).to eq(PropertyScraper)
    end

    it 'returns an instance of the class with a parish number supplied' do
      expect(parish_scraper.class).to eq(PropertyScraper)
    end
  end

  context '#results_page' do
    it 'returns a Mechanizer::Page object' do
      expect(string_scraper.results_page.class).to eq(Mechanize::Page)
    end
  end

  context '#count' do
    it 'returns the number of properties found' do
      expect(string_scraper.count).to eq(33)
    end

    it 'returns 0 if no properties are found' do
      expect(PropertyScraper.new('qqqqzq').count).to eq(0)
    end

    it 'returns 50 (site limit) if 50 or more properties are found' do
      expect(PropertyScraper.new('fliquet').count).to eq(50)
    end
  end

  context '#uprns' do
    it 'returns a list of uprns' do
      expect(string_scraper.uprns).to eq(UPRNS)
    end
  end

  context '#address' do
    it 'returns an array representing the address string' do
      expect(string_scraper.address(3)).to eq(LENORD.last[0].split('<br/>'))
    end
  end

  context '#parse' do
    it 'returns a 4 element array with all elements non-nil if address has valid postcode and parish' do
      add = ['line1', 'road', 'Trinity', 'JE1 1BJ']
      expect(string_scraper.parse(add)).to eq(['line1<br/>road<br/>Trinity<br/>JE1 1BJ', 'road', 12, 'JE1 1BJ'])
    end

    it 'last element is nil if last line is not a postcode' do
      add = ['line1', 'road', 'Trinity']
      expect(string_scraper.parse(add)).to eq(['line1<br/>road<br/>Trinity', 'road', 12, nil])
    end

    it 'last 2 elements are nil if last line is not a postcode or parish' do
      add = ['line1', 'road']
      expect(string_scraper.parse(add)).to eq(['line1<br/>road', 'road', nil, nil])
    end
  end

  context '#data' do
    it 'returns a 2D array of uprn/address array pairs' do
      expect(string_scraper.data.all? { |e| e.class == Array }).to be_truthy
    end

    it 'Address array element 0 is the html formatted address' do
      expect(string_scraper.data[3].last[0]).to eq(LENORD.last[0])
    end

    it 'Address array element 1 is the road, or nil' do
      expect(fourneaux.data.all? do |e|
        ALL_ROADS.any? { |road| e.last[1] == road }
      end).to be_truthy
    end

    it 'Address array element 2 is the parish number, or nil' do
      expect(fourneaux.data.all? do |e|
        [2, 11, nil].any? { |i| e.last[2] == i }
      end).to be_truthy
    end

    it 'Address array element 3 is a valid postcode, or nil' do
      expect(string_scraper.data.all? do |e|
        e.last[3] =~ /^JE\d \d[A-Z]{2}$/ || e.last[3].nil?
      end).to be_truthy
    end
  end

end
