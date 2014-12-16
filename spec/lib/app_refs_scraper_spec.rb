describe AppRefsScraper do

  let(:scraper) { AppRefsScraper.new(2013) }
  let(:page1_2013) { %w(P/2013/1848 P/2013/1847 P/2013/1846 P/2013/1843
                        P/2013/1842 A/2013/1845 A/2013/1844 RC/2013/1841
                        P/2013/1840 P/2013/1836) }

  it '#initialize' do
    expect(scraper).not_to be_nil
  end

  it '#json_for_page' do
    expect(scraper.json_for_page(1)).to include('Scroll down to view')
  end

  it '#app_refs_array' do
    expect(scraper.app_refs_array(1).size).to eq(10)
  end

  it '#app_refs_on_page' do
    expect(scraper.app_refs_on_page(1)).to eq(page1_2013)
  end

end
