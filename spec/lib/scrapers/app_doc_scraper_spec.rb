describe AppDocScraper do

  scraper = AppDocScraper.new
  let(:doc_types) { ['A', 'M'] }
  let(:meet_types) { ['PAP', 'MM'] }

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

  context "#links" do
    it 'should return the links to pdf downloads' do
      scraper.links.each do |link|
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

  context '#meet_types' do
    it 'should return an array only of correct meeting types' do
      expect(scraper.meet_types.all? { |type| meet_types.any? { |m| type == m } }).to be_truthy
    end
  end

  context '#key' do
    it 'should create a key of format: yymmdd_[PAP/MM]_[A/M]' do
      expect(scraper.key(0)) =~ /^\d{6}_(PAP|MM)_(A|M)$/
    end
  end

  context '#upload' do
    it 'should upload a pdf file to S3' do
      n = S3.list_objects(bucket: BUCKET).contents.count
      scraper.upload(0)
      expect(S3.list_objects(bucket: BUCKET).contents.count - n).to eq(1)
    end
  end

end
