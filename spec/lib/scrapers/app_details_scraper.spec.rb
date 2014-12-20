describe AppDetailsScraper do

  let(:scraper) { AppDetailsScraper.new('RW/2014/0548') }
  let(:details) { ["RW/2014/0548",
                   "RW",
                   "APPEAL",
                   "Richard Greig",
                   "Mr & Mrs R.I.G. Hardcastle, Le Mont Sohier, St. Brelade, JE3 8EA",
                   "Replace 5 No. windows on South elevation..... REQUEST FOR RECONSIDERATION for refusal of planning permission.",
                   "Homewood",
                   "Le Mont Sohier",
                   "St. Brelade",
                   "JE3 8EA",
                   "Built-Up Area, Green Backdrop Zone, Potential Listed Building, Primary Route Network",
                   ""
                   ] }
  let(:dates) { ["4th April 2014", "15th April 2014", "6th May 2014", "n/a",
                 "15th August 2014", "14th October 2014", "18th June 2014"
                 ] }
  let(:coords) { [49.185511, -2.191882] }

  it '#initialize' do
    expect(scraper).not_to be_nil
  end

  it '#det_t_ok?' do # validates table format
    expect(scraper.det_t_ok?).to be_truthy
  end

  it '#dat_t_ok?' do # validates table format
    expect(scraper.dat_t_ok?).to be_truthy
  end

  it '#app_details' do
    expect(scraper.app_details).to eq(details)
  end

  it '#app_dates' do
    expect(scraper.app_dates).to eq(dates)
  end

  it '#app_coords' do
    expect(scraper.app_coords).to eq(coords)
  end

  it '#app_data' do
    expect(scraper.app_data.size).to eq(14)
  end

end
