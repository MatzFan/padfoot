describe LocationScraper do

  UPRNS = [69213704, 69213730, 69213735, 69115918, 69115917, 69115921,
           69200044, 69213705, 69213728, 69213733, 69213895, 69300127,
           69115919, 69213907, 69214092, 69115916, 69200001, 69213732,
           69360012, 69213729, 69213736, 69213737, 69213906, 69402083,
           69150001, 69213731, 69213734, 69385980, 69115920, 69213702,
           69213884, 69213951, 69387750]

  LENORD = [69115918, ["Le Nord<br/>La Rue de Crabbe<br/>St. Mary<br/>JE3 3AD",
             8, 'JE3 3AD']]
  FOURNEAUX = [69407485, ['Fourneaux<br/>Le Clos Du Hambye<br/>La Route de la'+
                ' Hougue Bie<br/>St. Saviour<br/>JE2 7BS', 11, 'JE2 7BS']]

  string = 'crabbe'
  parish_num = 2
  string_scraper = LocationScraper.new(string)
  fourneaux = LocationScraper.new('fourneaux') # captures St. Brelade and St. Saviour
  parish_scraper = LocationScraper.new('fourneaux', 11) # 11 is St. Saviour

  context '#new' do
    it 'returns an instance of the class with no parish number supplied' do
      expect(string_scraper.class).to eq(LocationScraper)
    end

    it 'returns an instance of the class with a parish number supplied' do
      expect(parish_scraper.class).to eq(LocationScraper)
    end
  end

  context '#results_page' do
    it 'returns a Mechanizer::Page object' do
      expect(string_scraper.results_page.class).to eq(Mechanize::Page)
    end
  end

  context '#count' do
    it 'returns the number of locations found' do
      expect(string_scraper.count).to eq(33)
    end

    it 'returns 0 if no locations are found' do
      expect(LocationScraper.new('qqqqzq').count).to eq(0)
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

  context '#postcode_and_parishify' do
    it 'returns a 3 element array: [html address string, parish number, postcode]' do
      add = ['line1', 'line2', 'Trinity', 'JE1 1BJ']
      arr = ['line1<br/>line2<br/>Trinity<br/>JE1 1BJ', 12, 'JE1 1BJ']
      expect(string_scraper.postcode_and_parishify(add)).to eq(arr)
    end
  end

  context '#data' do
    it 'returns a 2D array of uprn/address array pairs' do
      expect(string_scraper.data.all? { |e| e.class == Array }).to be_truthy
    end

    it 'Address array element 0 is the html formatted address' do
      expect(string_scraper.data[3].last[0]).to eq(LENORD.last[0])
    end

    it 'Address array element 1 is the parish number, or nil' do
      expect(fourneaux.data.all? do |e|
        [2, 11, nil].any? { |i| e.last[1] == i }
      end).to be_truthy
    end

    it 'Address array element 2 is a valid postcode, or nil' do
      expect(string_scraper.data.all? do |e|
        e.last[2] =~ /^JE\d \d[A-Z]{2}$/ || e.last[2].nil?
      end).to be_truthy
    end
  end

end
