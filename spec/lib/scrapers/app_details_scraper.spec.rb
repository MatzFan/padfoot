describe AppDetailsScraper do

  let(:scraper) { AppDetailsScraper.new('P/2014/2191') }

  it '#initialize' do
    expect(scraper.details_title).to include('Planning Application Detail')
  end


end
