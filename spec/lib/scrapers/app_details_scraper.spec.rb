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
                   "" # no agent
                   ] }
  let(:dates) { ["4th April 2014", "15th April 2014", "6th May 2014", "n/a",
                 "15th August 2014", "14th October 2014", "18th June 2014"
                 ] }
  let(:coords) { [49.185511, -2.191882] }

  let(:data_hash) { { :Agent => '',
                      :Applicant => 'Mr & Mrs R.I.G. Hardcastle, Le Mont Sohier, St. Brelade, JE3 8EA',
                      :ApplicationAddress => 'Homewood',
                      :Category => 'RW',
                      :Constraints => 'Built-Up Area, Green Backdrop Zone, Potential Listed Building, Primary Route Network',
                      :Description => 'Replace 5 No. windows on South elevation..... REQUEST FOR RECONSIDERATION for refusal of planning permission.',
                      :Officer => 'Richard Greig',
                      :Parish => 'St. Brelade',
                      :PostCode => 'JE3 8EA',
                      :Reference => 'RW/2014/0548',
                      :RoadName => 'Le Mont Sohier',
                      :Status => 'APPEAL',
                      :Latitude => 49.185511,
                      :Longitude => -2.191882,
                      :ValidDate => '4th April 2014',
                      :AdvertisedDate => '15th April 2014',
                      :endpublicityDate =>'6th May 2014',
                      :SitevisitDate => 'n/a',
                      :CommitteeDate => '15th August 2014',
                      :Decisiondate => '14th October 2014',
                      :Appealdate => '18th June 2014',
                  } }

  it '#initialize' do
    expect(scraper).not_to be_nil
  end

  it '#has_valid_ref' do
    expect(AppDetailsScraper.new('garbage_app_ref').has_valid_ref).to be false
  end

  it '#det_t_ok?' do # validates details tables (2) format
    expect(scraper.det_t_ok?).to be_truthy
  end

  it '#dat_t_ok?' do # validates dates table format
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

  it '#data_hash returns hash of table titles and data' do
    expect(scraper.data_hash.size) == data_hash
  end

  # it '#app_data returns LESS THAN 21 items if parsing unsuccessful' do
  #   bad_dates_table_titles = scraper.send(:details_table_titles)
  #   allow(scraper).to receive(:dates_table_titles) { bad_dates_table_titles }
  #   expect(scraper.app_data.size).to be < 21
  # end

end
