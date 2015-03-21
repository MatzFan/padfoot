describe ParishScraper do

  let(:scraper) { ParishScraper.new(1, 1) }

  context '#new' do
    it 'can be instantiated with no args' do
      expect(ParishScraper.new).not_to be_nil
    end

    it 'can be instantiated with a matching lower_id and upper_id' do
      expect(scraper).not_to be_nil
    end
  end

  context '#num_records' do
    it 'returns the total number of properties' do
      expect(scraper.num_records).to eq(17) # not 12..
    end
  end

  context '#data' do
    it 'returns a 3D array of polygon ring coords' do
      expect(scraper.data).to eq([{object_id: 1, name: "St Clement"}])
    end
  end

  context '#rings' do
    it 'returns a 3D array of polygon ring coords' do
      rings = scraper.rings
      expect([rings.class, rings[0].class, rings[0][0].class]).to eq([Array, Array, Array])
    end

    it 'top level array size is 1 for contiguous parishes' do
      expect(scraper.rings.count).to eq(1)
    end

    it 'top level array size more than 1 for non contiguous parishes' do
      expect(ParishScraper.new(5, 5).rings.count).to eq(3) # Trinity!!
    end
  end

end
