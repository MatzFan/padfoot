describe OldPropertyScraper do

  ORDERED_UPRNS = [69127646, 69140406, 69387657]

  COORDS3 = [[33431, 64910.800000000745],
             [33355.799999999814, 64893.400000000373],
             [33483, 64866]]

  let(:scraper) { OldPropertyScraper.new(69003083) }
  let(:scraper3) { OldPropertyScraper.new(ORDERED_UPRNS) }

  context '#new' do
    it 'can be instantiated with no args' do
      expect(OldPropertyScraper.new.class).not_to be_nil
    end

    it 'can be instantiated with a single uprn' do
      expect(scraper.class).not_to be_nil
    end

    it 'can be instantiated with an ordered array of uprns' do
      expect(scraper3.class).not_to be_nil
    end

    it 'raises ArguementError if supplied UPRN array is not ordered' do
      NOT_ORDERED = ORDERED_UPRNS.reverse
      expect(->{ OldPropertyScraper.new(NOT_ORDERED) }).to raise_error(ArgumentError)
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
    it 'returns an SQL query to obtain all UPRNs, order by UPRN' do
      expect(scraper3.query_string).to eq('UPRN=69127646 OR UPRN=69140406 OR UPRN=69387657')
    end
  end

  context '#json' do
    it 'returns a JSON-parsed hash object' do
      expect(scraper.json.class).to eq(Hash)
    end
  end

  context '#x_y_coords' do
    it 'returns a 2D array of x & y GIS coords if provided with a single uprn' do
      expect(scraper.x_y_coords).to eq([[42035.15699999966, 65219.985874999315]])
    end

    it 'returns a 2D array of x & y GIS coords if provided with an array of uprns' do
      expect(scraper3.x_y_coords).to eq(COORDS3)
    end

    it 'raises UprnsDontMatchError if found UPRNs are differnt from those supplied' do
      expect(->{ OldPropertyScraper.new(ORDERED_UPRNS << 69999999).x_y_coords }).to raise_error(UprnsDontMatchError)
    end
  end

  context '#uprns' do
    it 'returns an array of output uprns if provided with a single uprn' do
      expect(scraper.uprns).to eq([69003083])
    end

    it 'returns an ordered array of output uprns, if an array provided' do
      expect(scraper3.uprns).to eq([69127646, 69140406, 69387657])
    end
  end

end
