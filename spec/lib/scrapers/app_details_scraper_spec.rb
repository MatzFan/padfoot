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
  let(:app_coords) { [49.185511, -2.191882] }

  let(:app_data_hash) { { :app_applicant => 'Mr & Mrs R.I.G. Hardcastle, Le Mont Sohier, St. Brelade, JE3 8EA',
                          :app_address => 'Homewood',
                          :app_category => 'RW',
                          :app_constraints => 'Built-Up Area, Green Backdrop Zone, Potential Listed Building, Primary Route Network',
                          :app_description => 'Replace 5 No. windows on South elevation..... REQUEST FOR RECONSIDERATION for refusal of planning permission.',
                          :app_officer => 'Richard Greig',
                          :app_parish => 'St. Brelade',
                          :app_postcode => 'JE3 8EA',
                          :app_ref => 'RW/2014/0548',
                          :app_road => 'Le Mont Sohier',
                          :app_status => 'APPEAL',
                          # :app_agent => '', # no agent in this example
                          :latitude => 49.185511,
                          :longitude => -2.191882,
                          :valid_date => '4th April 2014',
                          :advertised_date => '15th April 2014',
                          :end_pub_date =>'6th May 2014',
                          # :site_visit_date => 'n/a', # no site visit date in this example
                          :committee_date => '15th August 2014',
                          :decision_date => '14th October 2014',
                          :appeal_date => '18th June 2014',
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

  it '#coords' do
    expect(scraper.coords).to eq(app_coords)
  end

  # it '#coords_hash is empty if map is empty' do
  #   expect(AppDetailsScraper.new('???????').coords_hash).to eq({})
  # end

  it '#coords_hash is empty if there is no map' do
    expect(AppDetailsScraper.new('P/1997/2196').coords_hash).to eq({})
  end

  it '#coords_hash is empty if coords are nonsense' do
    expect(AppDetailsScraper.new('P/2000/2196').coords_hash).to eq({})
  end

  it '#data_hash returns hash of field names and data' do
    expect(scraper.data_hash).to eq(app_data_hash)
  end

  it '#app_data returns fewer items if parsing unsuccessful' do
    bad_dates_table_titles = scraper.send(:details_table_titles)
    allow(scraper).to receive(:dates_table_titles) { bad_dates_table_titles }
    expect(scraper.data_hash.size).to eq(13)
  end

end
