describe LocationScraper do

  UPRNS = [69213704, 69213730, 69213735, 69115918, 69115917, 69115921,
           69200044, 69213705, 69213728, 69213733, 69213895, 69300127,
           69115919, 69213907, 69214092, 69115916, 69200001, 69213732,
           69360012, 69213729, 69213736, 69213737, 69213906, 69402083,
           69150001, 69213731, 69213734, 69385980, 69115920, 69213702,
           69213884, 69213951, 69387750]

  LENORD = "Le Nord\nLa Rue de Crabbe\nSt. Mary\nJE3 3AD"
  FOURNEAUX = [[69407485, "Fourneaux\nLe Clos Du Hambye\nLa Route de la " +
                          "Hougue Bie\nSt. Saviour\nJE2 7BS"]]

  string = 'crabbe'
  parish_num = 2
  string_scraper = LocationScraper.new(string)
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
    it 'returns a single address at given index from search results' do
      expect(string_scraper.address(3)).to eq(LENORD)
    end
  end

  context '#data' do
    it 'returns a 2D array of uprn/address pairs' do
      expect(parish_scraper.data).to eq(FOURNEAUX)
    end
  end

end
