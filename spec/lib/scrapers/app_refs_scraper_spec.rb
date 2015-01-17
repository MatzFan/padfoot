describe AppRefsScraper do

  let(:scraper) { AppRefsScraper.new(2013) }
  let(:page3_2013) { %w(P/2013/1812 P/2013/1813 P/2013/1814 P/2013/1815
                        P/2013/1816 P/2013/1817 P/2013/1820 P/2013/1821
                        P/2013/1822 P/2013/1823) }

  it '#json_for_page' do
    expect(scraper.json_for_page(1)).to include('Scroll down to view')
  end

  it '#num_apps' do
    expect(scraper.num_apps).to eq(1449)
  end

  it '#num_pages' do
    expect(AppRefsScraper.new(2014).num_pages).to eq(161)
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
    it "should return 20 apps for 2013 if latest_app_num is '1833'" do
      scraper.instance_variable_set(:@latest_app_num, '1833') # simulates latest app ref '1833' in database
      expect(scraper.refs.count).to eq(20)
    end
  end

end
