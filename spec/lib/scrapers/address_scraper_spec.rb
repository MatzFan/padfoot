describe AddressScraper do

  ROADS = ['La Rue Baal', 'La Colomberie']
  CHEZ = ['Chez Jacques', '4', 'La Place Bisson', "Le Clos d'Avoine", 'La Rue Baal', 'St. Brelade', 'JERSEY', 'JE3 8HR']
  GOV = ['Governors House', '14', 'La Rue Baal', 'St. Brelade', 'JERSEY', 'JE3 8HQ']
  FORTYSEVEN = ['47', 'Keith Baal Gardens', 'La Colomberie', 'St. Helier', 'JERSEY', 'JE2 4GE']
  PO_BOX_581 = ['Lempiere,Whittaker,Renouf', 'PO Box 581', 'Rutland House', 'Pitt Street', 'St. Helier', 'JERSEY', 'JE4 0YL']
  string = 'baal'
  scraper = AddressScraper.new(string)
  jersey_post = ['Jersey Post', 'Postal Headquarters', '', 'JERSEY', 'JE1 1AA']
  je1_1aa_scraper = AddressScraper.new('je1 1aa')
  po_box_603_scraper = AddressScraper.new('po box 603')
  po_box_581_scraper = AddressScraper.new('po box 581')
  po_box_235_scraper = AddressScraper.new('po box 235')

  context '#new' do
    it 'returns an instance of the class' do
      expect(scraper.class).to eq(AddressScraper)
    end
  end

  context '#num_addresses' do
    it 'returns the number of addresses found' do
      expect(scraper.num_addresses).to eq(82)
    end

    it 'returns 1 if 1 address is found' do
      expect(po_box_603_scraper.num_addresses).to eq(1)
    end

    it 'returns 0 if no addresses are found' do
      expect(AddressScraper.new('qzxz').num_addresses).to eq(0)
    end
  end

  context '#raw_adds' do
    it 'returns an empty array if no addresses are found' do
      expect(AddressScraper.new('qzxz').raw_adds).to eq([])
    end

    it 'returns a 2D array of addresses containing the search string, if any are found' do
      expect(scraper.raw_adds.all? { |arr| arr.any? { |s| s.downcase.include?(string) } }).to be_truthy
    end

    it 'can return an arrays of length 4 or more' do
      expect(scraper.raw_adds.all? { |arr| arr.length > 4 }).to be_truthy
    end

    it 'can return an array of length 9' do
      expect(po_box_603_scraper.raw_adds[0].length).to eq(9)
    end

    it 'treats comma-separated text as one string (delimiter is ", ")' do
      expect(po_box_581_scraper.raw_adds[0]).to eq(PO_BOX_581)
    end
  end

  context '#addresses' do
    it 'returns a 2D array of address data' do
      expect(scraper.addresses.all? { |e| e.class == Array }).to be_truthy
    end

    it 'returns array of arrays of length 4' do
      expect(scraper.addresses.all? { |a| a.length == 4 }).to be_truthy
    end

    it 'returns arrays whose first element is an address String' do
      expect(scraper.addresses.last[0].class).to eq(String)
    end

    it 'returns arrays whose second element is the road name' do
      expect(scraper.addresses.all? { |arr| ROADS.any? { |r| r == arr[1] } }).to be_truthy
    end

    it 'returns arrays whose second element (road name) will be nil if address has no parish' do
      expect(je1_1aa_scraper.addresses[0][1]).to be_nil
    end

    it 'returns arrays whose third element is the parish number (1 to 12)' do
      expect(scraper.addresses.all? { |arr| (1..12).any? { |p| p == arr[2] } }).to be_truthy
    end

    it 'returns arrays whose third element (parish number) may be nil' do
      expect(je1_1aa_scraper.addresses[0][2]).to be_nil
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

    it 'omits blank parish names from the string' do
      expect(scraper.htmlify(jersey_post)).to eq('Jersey Post<br/>Postal Headquarters<br/>JE1 1AA')
    end
  end

end
