describe AppDetailsScraper do

  ex_ref = 'RW/2014/0548'
  bad_ref = 'A/bad/app_ref'
  scraper = AppDetailsScraper.new([ex_ref, bad_ref])

  let(:single) { AppDetailsScraper.new(ex_ref) }

  let(:space) { 'S/2014/1979' }
  let(:s_repeat_space) { AppDetailsScraper.new(space) }
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

  context '#initialize' do
    it 'can be initialized with a single arguement' do
      expect(AppDetailsScraper.new('RW/2014/0548')).not_to be_nil
    end

    it 'can be initialized with an array' do
      expect(scraper).not_to be_nil
    end

    context '#det_pages' do
      it 'scraper object stores Mechanizer::Page objects for valid app_refs' do
        expect(single.det_pages[0].class).to eq(Mechanize::Page)
      end

      it 'scraper object stores nils for invalid app_refs' do
        expect(scraper.det_pages[1]).to be_nil
      end
    end
  end

  context '#table_ok?' do
    context "doesn't raise an error" do
      it 'if the details table format is ok' do
        expect(lambda {scraper.table_ok?(0, 'details')}).not_to raise_error
      end

      it 'if the dates table format is ok' do
        expect(lambda {scraper.table_ok?(0, 'dates')}).not_to raise_error
      end
    end

    context "does raise an error" do
      it 'if the details table format is bad' do
        err = "Bad details table structure for #{ex_ref}"
        dat_page = single.instance_variable_get(:@dat_pages)[0]
        single.instance_variable_set(:@det_pages, [dat_page])
        expect(lambda {single.table_ok?(0, 'details')}).to raise_error(err)
      end

      it 'if the dates table format is bad' do
        err = "Bad dates table structure for #{ex_ref}"
        det_page = single.instance_variable_get(:@det_pages)[0]
        single.instance_variable_set(:@dat_pages, [det_page])
        expect(lambda {single.table_ok?(0, 'dates')}).to raise_error(err)
      end
    end
  end

  it '#app_details' do
    expect(scraper.app_details(0)).to eq(details)
  end

  context '#format_date' do
    it 'should correctly format a valid date' do
      expect(scraper.format_date('4th April 2014').class).to eq(Date)
    end

    it 'should returns nil for "n/a"' do
      expect(scraper.format_date('n/a')).to be_nil
    end
  end

  it '#app_dates' do
    expect(single.app_dates(0).map { |d| d.to_s }).to eq(dates)
  end

  it '#coords' do
    expect(scraper.coords(0)).to eq(app_coords)
  end

  context '#coords_hash' do
    it 'should be empty if map is empty' do
      ref = 'P/2012/0219'
      expect(AppDetailsScraper.new(ref).coords_hash(0)).to eq({})
    end

    it '#coords_hash is empty if there is no map' do
      ref = 'P/1997/2196'
      expect(AppDetailsScraper.new(ref).coords_hash(0)).to eq({})
    end

    it '#coords_hash is empty if coords are nonsense' do
      ref = 'P/2000/2196'
      expect(AppDetailsScraper.new(ref).coords_hash(0)).to eq({})
    end
  end

  context '#data_hash' do
    it 'returns hash of field names and data' do
      expect(scraper.data_hash(0)).to eq(app_data_hash)
    end

    it 'returns strings cleaned of leading, trailing & repeated spaces' do
      expect(s_repeat_space.data_hash(0)[:app_postcode]).to eq('JE3 3DA')
    end
  end

  context '#data_hash_arr' do
    it 'returns an array of hashes the same size as the number of args provided' do
      expect(scraper.data_hash_arr.size).to eq(2)
      expect(single.data_hash_arr.size).to eq(1)
    end

    it 'returns an array of hashes of field names and data for a valid ref' do
      expect(scraper.data_hash_arr[0]).to eq(app_data_hash)
    end

    it 'returns an empty hash for an invalid ref' do
      expect(scraper.data_hash_arr[1]).to eq({})
    end
  end

end
