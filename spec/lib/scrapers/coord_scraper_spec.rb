describe CoordScraper do

  let(:scraper) { CoordScraper.new(69003083) }

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
    it 'returns the x & y GIS coords' do
      expect(scraper.x_y_coords).to eq([42035.15699999966, 65219.985874999315])
    end
  end

end
