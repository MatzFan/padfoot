describe AppDetailsScraper do

  let(:scraper) { AppDetailsScraper.new('RW/2014/0548') }
  let(:details) { ["RW/2014/0548",
                   "RW",
                   "Upheld",
                   "Richard Greig",
                   "Mr & Mrs R.I.G. Hardcastle, Le Mont Sohier, St. Brelade, JE3 8EA",
                   "Replace 5 No. windows on South elevation..... REQUEST FOR RECONSIDERATION for refusal of planning permission.",
                   "Homewood",
                   "Le Mont Sohier",
                   "St. Brelade",
                   "JE3 8EA",
                   "Built-Up Area, Green Backdrop Zone, Potential Listed Building, Primary Route Network",
                   nil # no agent
                   ] }
  let(:dates) { ["2014-04-04", "2014-04-15", "2014-05-06", "",
                 "2014-08-15", "2014-10-14", "2014-06-18"
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
                          :app_status => 'Upheld',
                          :app_agent => nil, # no agent in this example
                          :latitude => 49.185511,
                          :longitude => -2.191882,
                          :valid_date => Date.parse('2014-04-04'),
                          :advertised_date => Date.parse('2014-04-15'),
                          :end_pub_date => Date.parse('2014-05-06'),
                          :site_visit_date => nil, # no site visit date in this example
                          :committee_date => Date.parse('2014-08-15'),
                          :decision_date => Date.parse('2014-10-14'),
                          :appeal_date => Date.parse('2014-06-18'),
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

  it '#format_date' do
    expect(scraper.format_date('4th April 2014').class).to eq(Date)
  end

  it '#format_date for "n/a" returns nil' do
    expect(scraper.format_date('n/a')).to be_nil
  end

  it '#app_dates' do
    expect(scraper.app_dates.map { |date| date.to_s }).to eq(dates)
  end

  it '#coords' do
    expect(scraper.coords).to eq(app_coords)
  end

  it '#coords_hash is empty if map is empty' do
    expect(AppDetailsScraper.new('P/2012/0219').coords_hash).to eq({})
  end

  it '#coords_hash is empty if there is no map' do
    expect(AppDetailsScraper.new('P/1997/2196').coords_hash).to eq({})
  end

  it '#coords_hash is empty if coords are nonsense' do
    expect(AppDetailsScraper.new('P/2000/2196').coords_hash).to eq({})
  end

  context '#data_hash' do
    it 'returns hash of field names and data' do
      expect(scraper.data_hash).to eq(app_data_hash)
    end

    it 'returns strings cleaned of leading, trailing & repeated spaces' do
      expect(AppDetailsScraper.new('S/2014/1979').data_hash[:app_postcode]).to eq('JE3 3DA')
    end
  end

end
