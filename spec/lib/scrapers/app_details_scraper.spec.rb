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

  xit '#valid_details_page?' do
    expect(scraper.valid_details_page?).to be_truthy
  end

  xit '#t_valid?' do
    expect(scraper.t_valid?).to be_truthy
  end

  it '#details_data' do
    expect(scraper.details_data).to eq(details)
  end

end
