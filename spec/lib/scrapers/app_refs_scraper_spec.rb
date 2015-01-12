describe AppRefsScraper do

  year, ref = 2013, '1833'

  let(:scraper) { AppRefsScraper.new(year, ref) }
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

  context '#latest_refs' do
    it "should return 20 apps for #{year} app ref: #{ref}" do
      expect(scraper.latest_refs.count).to eq(20)
    end

    it "should return 23 apps when no args passed" do
      expect(AppRefsScraper.new.latest_refs.count).to eq(23)
    end

  end

end
