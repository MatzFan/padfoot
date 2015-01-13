describe AppRefsScraper do

  year = 2013
  number = '1833'

  let(:scraper) { AppRefsScraper.new(year) }
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
    expect(AppRefsScraper.new(2015).num_pages).to eq(3)
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
    it "should return 20 apps for #{year} app ref: #{number}" do
      allow(scraper).to receive(:latest_app_num) { number } # stub to simulate database read
      expect(scraper.refs.count).to eq(20)
    end
  end

end
