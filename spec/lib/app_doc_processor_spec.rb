describe AppDocProcessor do

  processor = AppDocProcessor.new
  scraper = processor.scraper
  meeting_hash = { type: 'MM', date: Date.new(2014,06,16) }

  context '#new' do
    it 'should return an instance of the class' do
      expect(processor.class).to eq(AppDocProcessor)
    end
  end

  context '#create_meetings' do
    it 'should not create a meeting if it exists' do
      Meeting.create(meeting_hash)
      allow(scraper).to receive(:meet_data) { [meeting_hash] }
      processor.create_meetings
      expect(Meeting.count).to eq(1)
    end

    it 'should create a meeting if it does not exist' do
      allow(scraper).to receive(:meet_data) { [meeting_hash] }
      processor.create_meetings
      expect(Meeting.count).to eq(1)
    end
  end

  context '#new_doc_data' do
    it 'returns an array of data hashes for new documents (not yet in S3)' do
      expect(processor.new_doc_data.count).to eq(26)
    end
  end

  context '#meeting_data' do
    it 'returns an array of data hashes for the meetings associated with new documents' do
      expect(processor.meeting_data.count).to eq(26)
    end
  end

  context '#new_docs' do
    it 'returns an array of Document objects' do
      expect(processor.new_docs.all? { |doc| doc.class == Document }).to be_truthy
    end
  end

  context '#links' do
    it 'returns an array of strings representing .pdf links' do
      expect(processor.links.all? { |s| s[-4..-1] == '.pdf' }).to be_truthy
    end
  end

  xcontext '#docs_with_urls' do
    it 'uploads a document from a link' do

    end

    it 'returns document objects with :url set' do

    end
  end

end
