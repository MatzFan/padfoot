describe AppDocScraper do

  scraper = AppDocScraper.new
  let(:doc_types) { ['Agenda', 'Minutes'] }
  let(:meet_types) { ['PAP', 'MM'] }

  context '#new' do
    it 'should return an instance of the class' do
      expect(scraper.class).to eq(AppDocScraper)
    end
  end

  context '#page' do
    it "should return the agendas/minutes page source" do
      expect(scraper.page.title).to include('Agendas and minutes')
    end
  end

  context '#verify_structure' do
    it 'raises an error (in constructor) if page structure is not as expected' do
      allow(scraper).to receive(:tables) { [] } # zero length array
      expect(->{ scraper.verify_structure }).to raise_error
    end
  end

  context '#table_titles' do
    it 'returns an array of the table titles for each set of meetings' do
      expect(scraper.table_titles.all? {|s| s.include?('meetings') }).to be_truthy
    end
  end

  context '#table_years' do
    it 'returns an array of the year extracted from the table titles, if any' do
      expect(scraper.table_years).to eq([nil,2014,2014])
    end
  end

  context '#table_types' do
    it 'returns an array of the table meeting type, if any' do
      expect(scraper.table_types).to eq(['?','PAP','MM'])
    end
  end

  context '#links' do
    it 'returns an array of pdf links from each table' do
      expect(scraper.links.all? { |link| link[-4..-1] == '.pdf'}).to be_truthy
    end
  end

  context '#meet_types' do
    it 'should return an array only of correct meeting types' do
      expect(scraper.meet_types.all? { |type| meet_types.any? { |m| type == m } }).to be_truthy
    end
  end

  context '#table_link_names' do
    it 'should return an array document link-names' do
      expect(scraper.table_link_names.all? do |t|
        t.all? { |s| s.include?('Download ') }
      end).to be_truthy
    end
  end

  context '#doc_dates' do
    it 'should return an array only of valid dates' do
      expect(scraper.doc_dates.all? { |e| e.kind_of?(Date) }).to be_truthy
    end
  end

  context '#doc_types' do
    it 'should return an array only of correct document types' do
      expect(scraper.doc_types.all? { |type| doc_types.any? { |m| type == m } }).to be_truthy
    end
  end

  context '#file_names' do
    it 'returns an array of strings of format: yymmdd_[PAP/MM]_[A/M]' do
      expect(scraper.file_names.all? { |s| s =~ /^\d{6}_(PAP|MM)_(A|M)$/ }).to be_truthy
    end
  end

  context '#meet_data' do
    it 'returns a 2D array of meetings data hashes: {type: xxx date: xxx}' do
      expect(scraper.meet_data.all? do |arr|
        meet_types.any? { |m| arr[:type] == m } && arr[:date].kind_of?(Date)
      end).to be_truthy
    end
  end

end
