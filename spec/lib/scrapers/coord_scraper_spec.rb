describe CoordScraper do

  COORDS = [[34911, 72269.80000000075], [34510.700000000186, 65457.40000000037]]
  DATA = [['Field No. 320', [34911, 72269.80000000075]], ['Field No. 320', [34510.700000000186, 65457.40000000037]]]

  let(:scraper) { CoordScraper.new([69003083]) }
  let(:multi_scraper) { CoordScraper.new([69214997, 69209790])}

  context '#new' do
    it 'returns an instance of the class' do
      expect(scraper.class).to eq(CoordScraper)
    end
  end

  context '#validate' do
    it 'does not raise an error if the page structure is as expected' do
      expect(->{ scraper.validate }).not_to raise_error
    end
  end

  context '#uprn_string' do
    it 'builds an SQL query to retrieve all uprns' do
      scraper.instance_variable_set(:@uprns, [12345678, 23456789])
      expect(scraper.uprn_string).to eq('UPRN=12345678 OR UPRN=23456789')
    end
  end

  context '#form' do
    it 'returns an instance of Mechanize::Form class' do
      expect(scraper.form.class).to eq(Mechanize::Form)
    end
  end

  context '#json' do
    it 'returns a JSON-parsed hash object' do
      expect(scraper.json.class).to eq(Hash)
    end
  end

  context '#x_y_coords' do
    it 'returns a 2D array of x & y GIS coords for a single UPRN' do
      expect(scraper.x_y_coords).to eq([[42035.15699999966, 65219.985874999315]])
    end

    it 'returns a 2D array of x & y GIS coords for a multiple UPRNs' do
      expect(multi_scraper.x_y_coords).to eq(COORDS)
    end
  end

  context '#add1s' do
    it 'returns the 1st line of the address for a single UPRN' do
      expect(scraper.add1s).to eq(['25 Pier Road'])
    end

    it 'returns the 1st line of the address for multiple UPRNs' do
      expect(multi_scraper.add1s).to eq(['Field No. 320', 'Field No. 320'])
    end
  end

  context '#data' do
    it 'returns an array of 2D arrays: [add1, [coords]] for every uprn' do
      expect(multi_scraper.data).to eq(DATA)
    end
  end

end
