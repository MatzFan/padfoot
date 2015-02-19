describe AppDocProcessor do

  processor = AppDocProcessor.new
  date = Date.parse(Time.now.strftime("%y%m%d"))
  new_data = [[{type: "doc_type", name: "new_doc_name", link: "link_to_a.pdf"}, {type: "meet_type", date: date }]] # single doc & meeting
  processor.instance_variable_set(:@new_data, new_data)
  scraper = processor.scraper
  meeting_hash = { type: 'MM', date: Date.new(2014,06,16) }
  let(:doc) { create(:document) }

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
      expect(processor.new_doc_data.count).to eq(1)
    end
  end

  context '#meeting_data' do
    it 'returns an array of data hashes for the meetings associated with new documents' do
      expect(processor.meeting_data.count).to eq(1)
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

  context '#link_apps' do
    it 'links PlanningApp objects to a document' do
      app1, app2 = create(:planning_app), create(:planning_app)
      processor.link_apps(doc, [app1.app_ref, app2.app_ref])
      expect(Document.first.planning_apps.count).to eq(2)
    end
  end

end
