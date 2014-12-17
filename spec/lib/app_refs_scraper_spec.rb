describe AppRefsScraper do

  let(:scraper) { AppRefsScraper.new(2013, '1833') }
  let(:page3_2013) { %w(P/2013/1812 P/2013/1813 P/2013/1814 P/2013/1815
                        P/2013/1816 P/2013/1817 P/2013/1820 P/2013/1821
                        P/2013/1822 P/2013/1823) }

  it '#json_for_page' do
    expect(scraper.json_for_page(1)).to include('Scroll down to view')
  end

  it '#num_apps' do
    expect(scraper.num_apps).to eq(1447)
  end

  it '#app_refs_array' do
    expect(scraper.app_refs_array(1).size).to eq(10)
  end

  it '#app_refs_on_page' do
    expect(scraper.app_refs_on_page(3)).to match_array(page3_2013)
  end

  it '#latest_refs' do
    expect(scraper.latest_refs.count).to eq(20)
  end

end