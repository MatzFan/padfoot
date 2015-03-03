describe AddressScraper do

  ROADS = ['La Rue Baal', 'La Colomberie']
  PARISHES = ['St. Brelade', 'St. Helier']
  CHEZ = ['Chez Jacques', '4', 'La Place Bisson', "Le Clos d'Avoine", 'La Rue Baal', 'St. Brelade', 'JERSEY', 'JE3 8HR']
  GOV = ['Governors House', '14', 'La Rue Baal', 'St. Brelade', 'JERSEY', 'JE3 8HQ']
  FORTYSEVEN = ['47', 'Keith Baal Gardens', 'La Colomberie', 'St. Helier', 'JERSEY', 'JE2 4GE']
  string = 'baal'
  scraper = AddressScraper.new(string)

  context '#new' do
    it 'returns an instance of the class' do
      expect(scraper.class).to eq(AddressScraper)
    end
  end

  context '#num_addresses' do
    it 'returns the number of addresses found' do
      expect(scraper.num_addresses).to eq(82)
    end

    it 'returns the 0 if no addresses are found' do
      expect(AddressScraper.new('qzxz').num_addresses).to eq(0)
    end
  end

  context '#raw_addresses' do
    it 'returns an empty array if no addresses are found' do
      expect(AddressScraper.new('qzxz').raw_addresses).to eq([])
    end

    it 'returns a 2D array of addresses containing the search string, if any are found' do
      expect(scraper.raw_addresses.all? { |arr| arr.any? { |s| s.downcase.include?(string) } }).to be_truthy
    end

    it 'returns arrays of maximum length 8' do
      expect(scraper.raw_addresses.all? { |arr| arr.length < 9 }).to be_truthy
    end

    it 'returns arrays of minimum length 5' do
      expect(scraper.raw_addresses.all? { |arr| arr.length > 4 }).to be_truthy
    end
  end

  context '#addresses' do
    it 'returns a 2D array of address data' do
      expect(scraper.addresses.all? { |e| e.class == Array }).to be_truthy
    end

    it 'returns array of arrays of length 4' do
      expect(scraper.addresses.all? { |a| a.length == 4 }).to be_truthy
    end

    it 'returns arrays whose first element is the html formatted full address' do
      expect(scraper.addresses.last[0]).to eq('47 Keith Baal Gardens<br/>La Colomberie<br/>St. Helier<br/>JE2 4GE')
    end

    it 'returns arrays whose second element is the road name' do
      expect(scraper.addresses.all? { |arr| ROADS.any? { |r| r == arr[1] } }).to be_truthy
    end

    it 'returns arrays whose third element is the parish name, or nil' do
      expect(scraper.addresses.all? { |arr| PARISHES.any? { |p| p == arr[2] } }).to be_truthy
    end

    it 'returns arrays whose last element is a postcode' do
      expect(scraper.addresses.all? { |a| a.last =~ /JE\d \d[A-Z]{2}/ }).to be_truthy
    end
  end

  context '#htmlify' do
    it 'returns an html formatted represenation of the address, with numbers on same line as following element' do
      expect(scraper.htmlify(CHEZ)).to eq("Chez Jacques<br/>4 La Place Bisson"+
        "<br/>Le Clos d'Avoine<br/>La Rue Baal<br/>St. Brelade<br/>JE3 8HR")
    end

    it 'returns an html formatted represenation of the address, with numbers on same line as the road, if applicable' do
      expect(scraper.htmlify(GOV)).to eq("Governors House<br/>14 La Rue Baal<br/>St. Brelade<br/>JE3 8HQ")
    end

    it 'returns a string representing the street address, with numbers placed on the same line as following element' do
      expect(scraper.htmlify(FORTYSEVEN)).to eq('47 Keith Baal Gardens<br/>La Colomberie<br/>St. Helier<br/>JE2 4GE')
    end
  end

end
