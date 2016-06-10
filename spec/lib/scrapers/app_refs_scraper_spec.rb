describe AppRefsScraper do
  let(:scraper) { AppRefsScraper.new(2013) }
  let(:page3_2013) do
    %w(P/2013/1812 P/2013/1813 P/2013/1814 P/2013/1815 P/2013/1816 P/2013/1817
       P/2013/1820 P/2013/1821 P/2013/1822 P/2013/1823)
  end

  it '#json_for_page' do
    expect(scraper.json_for_page(1)).to include('Scroll down to view')
  end

  context '#num_apps' do
    it 'should return correct number of apps for a valid year - e.g. 2013' do
      expect(scraper.num_apps).to eq(1462)
    end

    it 'should return 0 for an invalid year - e.g. 9999' do
      expect(AppRefsScraper.new(9999).num_apps).to eq(0)
    end
  end

  context '#num_pages' do
    it 'should correctly identify number apps / 10 rounded up' do
      allow(scraper).to receive(:num_apps) { 1605 }
      expect(scraper.num_pages).to eq(161)
    end

    it 'should correctly deal with 0' do
      allow(scraper).to receive(:num_apps) { 0 }
      expect(scraper.num_pages).to eq(0)
    end

    it 'should correctly deal with a round number like 2,000' do
      allow(scraper).to receive(:num_apps) { 2000 }
      expect(scraper.num_pages).to eq(200)
    end
  end

  it '#app_refs_array' do
    expect(scraper.app_refs_array(1).size).to eq(10)
  end

  it '#app_refs_on_page' do
    expect(scraper.app_refs_on_page(3)).to match_array(page3_2013)
  end

  context '#latest_app_num' do
    it 'should return "0000" if no applications in database' do
      expect(scraper.latest_app_num).to eq('0000')
    end
  end

  context '#refs' do
    it "returns 20 apps for 2013 if latest_app_num is '1833'" do
      scraper.instance_variable_set(:@latest_app_num, '1833')
      expect(scraper.refs.count).to eq(20)
    end

    it 'returns 42 apps for 2013 if page param set to 143' do
      expect(AppRefsScraper.new(2013, 143).refs.count).to eq(42)
    end

    it 'returns all 384 app refs for 1988 if page param set to -1' do
      expect(AppRefsScraper.new(1988, -1).refs.count).to eq(384)
    end
  end
end
