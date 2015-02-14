describe AppDocScraper do

  let(:scraper) { AppDocScraper.new }
  let(:doc_types) { ['Agenda', 'Minutes'] }
  let(:meet_types) { ['Panel', 'Ministerial'] }

  context '#new' do
    it 'should return an instance of the class' do
      expect(scraper.class).to eq(AppDocScraper)
    end
  end

  context "#page" do
    it "should return the agendas/minutes page source" do
      expect(scraper.page.title).to include('Agendas and minutes')
    end
  end

  context "#doc_links" do
    it 'should return the links to pdf downloads' do
      scraper.doc_links.each do |link|
        expect(link.uri.to_s[-4..-1]).to eq('.pdf')
      end
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

  context '#meeting_types' do
    it 'should return an array only of correct meeting types' do
      expect(scraper.meeting_types.all? { |type| meet_types.any? { |m| type == m } }).to be_truthy
    end
  end

  context '#upload_to_s3' do
    it 'should upload a pdf file to S3' do
      scraper.upload_to_s3
      expect(S3.list_objects(bucket: 'padfoot', max_keys: 1)).not_to be_nil
    end
  end

end
