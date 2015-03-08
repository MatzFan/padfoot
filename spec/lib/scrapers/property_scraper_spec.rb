describe PropertyScraper do

  SCRAPER3_XS = [38038.400000000373, 42035.15699999966, 42035.500500000082]

  SCRAPER3_YS = [73081.400000000373, 65219.985874999315, 65219.92775000073]

  SCRAPER3_COORDS = [[{:x=>38038.400000000373}, {:y=>73081.400000000373}],
                     [{:x=>42035.15699999966}, {:y=>65219.985874999315}],
                     [{:x=>42035.500500000082}, {:y=>65219.92775000073}]]

  ARRAY_OF_HASHES1 = [[{objectid: 29727}, {guid_: 10593}, {add1: "25 Pier Road"}, {add2: nil}, {add3: nil}, {add4: nil}, {parish: 4}, {postcode: "JE2 4XW"}, {uprn: 69003083}, {usrn: 40002299}, {property_type: "Commercial"}, {address1: "25 PIER ROAD,"}, {vingtaine: "de Haut de la Ville"}]]

  ARRAY_OF_HASHES3 = [[{objectid: 29726}, {guid_: 38053}, {add1: "Field No. 45"}, {add2: "La Rue de Sorel"}, {add3: nil}, {add4: nil}, {parish: 5}, {postcode: nil}, {uprn: 69211091}, {usrn: 40000884}, {property_type: "Agricultural"}, {address1: "FIELD NO. 45,LA RUE DE SOREL,"}, {vingtaine: "Douet"}],
                      [{objectid: 29727}, {guid_: 10593}, {add1: "25 Pier Road"}, {add2: nil}, {add3: nil}, {add4: nil}, {parish: 4}, {postcode: "JE2 4XW"}, {uprn: 69003083}, {usrn: 40002299}, {property_type: "Commercial"}, {address1: "25 PIER ROAD,"}, {vingtaine: "de Haut de la Ville"}],
                      [{objectid: 29728}, {guid_: 31331}, {add1: "Digimap (Jersey) Limited"}, {add2: "25 Pier Road"}, {add3: nil}, {add4: nil}, {parish: 4}, {postcode: "JE2 4XW"}, {uprn: 69305388}, {usrn: 40002299}, {property_type: "Commercial"}, {address1: "DIGIMAP (JERSEY) LIMITED,25 PIER ROAD,"}, {vingtaine: "de Haut de la Ville"}]]

  SCRAPER_DATA = [{x: 42035.15699999966, y: 65219.985874999315, objectid: 29727, guid_: 10593, add1: "25 Pier Road", add2: nil, add3: nil, add4: nil, parish: 4, postcode: "JE2 4XW", uprn: 69003083, usrn: 40002299, property_type: "Commercial", address1: "25 PIER ROAD,", vingtaine: "de Haut de la Ville"}]

  SCRAPER3_DATA =

  let(:scraper) { PropertyScraper.new(29727, 29727) }
  let(:scraper3) { PropertyScraper.new(29726, 29728) } # range of 3 ids

  context '#new' do
    it 'can be instantiated with no args' do
      expect(PropertyScraper.new).not_to be_nil
    end

    it 'can be instantiated with a matching lower_id and upper_id' do
      expect(scraper).not_to be_nil
    end

    it 'can be instantiated with a different lower_id and upper_id' do
      expect(scraper3).not_to be_nil
    end
  end

  context '#form' do
    it 'returns an instance of Mechanize::Form class' do
      expect(scraper.form.class).to eq(Mechanize::Form)
    end
  end

  context '#validate' do
    it 'does not raise an error if the page structure is as expected' do
      expect(->{ scraper.validate }).not_to raise_error
    end
  end

  context '#num_props' do
    it 'returns the total number of properties' do
      expect(scraper.num_props).to eq(67537)
    end
  end

  context '#query_string' do
    it 'returns an SQL query to obtain the ids in the params range' do
      expect(scraper3.query_string).to eq('OBJECTID >= 29726 AND OBJECTID <= 29728')
    end
  end

  context '#json' do
    it 'returns a JSON-parsed hash object' do
      expect(scraper.json.class).to eq(Hash)
    end
  end

  context '#xes' do
    it 'returns array of x GIS coords for a single id range' do
      expect(scraper.xes).to eq([42035.15699999966])
    end

    it 'returns array of x GIS coords for a multiple ids range' do
      expect(scraper3.xes).to eq(SCRAPER3_XS)
    end
  end

  context '#yes' do
    it 'returns array of x GIS coords for a single id range' do
      expect(scraper.yes).to eq([65219.985874999315])
    end

    it 'returns array of y GIS coords for a multiple ids range' do
      expect(scraper3.yes).to eq(SCRAPER3_YS)
    end
  end

   context '#coords' do
    it 'returns array of x, y coordinate for a single id range' do
      expect(scraper.coords).to eq([[{x: 42035.15699999966}, {y: 65219.985874999315}]])
    end

    it 'returns array of y GIS coords for a multiple ids range' do
      expect(scraper3.coords).to eq(SCRAPER3_COORDS)
    end
  end

  context '#hashy' do
    it 'returns an array of hashes for the data parameter provided for a single id range' do
      expect(scraper.hashy('Property_Type')).to eq([{ property_type: 'Commercial' }])
    end

    it 'returns an array of hashes for the data parameter provided for a multiple id range' do
      expect(scraper3.hashy('UPRN')).to eq([{ uprn: 69211091 }, { uprn: 69003083 }, { uprn: 69305388 }])
    end
  end

  context '#array_of_hashes' do
    it 'returns a 2D array of hashes for all data parameters for a single id range' do
      expect(scraper.array_of_hashes).to eq ARRAY_OF_HASHES1
    end

    it 'returns a 2D array of hashes for all data parameters for a multiple id range' do
      expect(scraper3.array_of_hashes).to eq ARRAY_OF_HASHES3
    end
  end

  context '#process' do
    it 'processes a valid parish name to return its parish num if key is "Parish"' do
      PARISHES.map(&:upcase).each_with_index do |parish, i|
        expect(scraper.process('Parish', parish)).to eq(i + 1)
      end
    end

    it 'processes an invalid parish name to return nil if key is "Parish"' do
      expect(scraper.process('Parish', 'not a parish')).to be_nil
    end
  end

  context '#data' do
    it 'returns an array of data hashes' do
      expect(scraper.data).to eq(SCRAPER_DATA)
    end
  end

end
