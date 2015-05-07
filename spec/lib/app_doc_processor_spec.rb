describe AppDocProcessor do

  S3_URL = 'https://meetingdocuments.s3.amazonaws.com/150128_PAP_M' # care if renaming bucket
  PAGE_REFS = [[1, ["P/2014/1777"]], [2, ["P/2014/1061", "RC/2014/1504"]],
               [3, ["P/2009/2253", "P/2014/1165"]], [4, ["P/2014/1587"]], [6, ["PP/2014/1794",
                "P/2009/1871"]], [7, ["RM/2014/1173"]], [9, ["P/2014/1246"]],
                [11, ["S/2014/1606"]], [13, ["P/2014/1521"]],[16, ["P/2014/1646"]],
                [17, ["PP/2014/1302", "RP/2014/0880"]], [18, ["P/2014/1444"]]]

  processor = AppDocProcessor.new
  date = Date.parse(Time.now.strftime("%y%m%d"))
  new_data = [[{type: "doc_type", name: "new_doc_name", link: "link_to_a.pdf"}, {type: "meet_type", date: date }]] # single doc & meeting
  processor.instance_variable_set(:@new_data, new_data)
  scraper = processor.scraper
  meeting_hash = { type: 'MM', date: Date.new(2014,06,16) }
  let(:doc) { create(:document) }

  def sample_doc_text
    begin
      open('temp_pdf', 'wb') { |file| file << open(S3_URL).read }
      text = `pdftotext -enc UTF-8 temp_pdf -`
    rescue
    ensure
      File.delete('temp_pdf')
    end
    text
  end


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
    it 'links PlanningApp objects to a document if the apps exist in DB' do
      app1, app2 = create(:planning_app), create(:planning_app)
      processor.link_apps(doc, [[1, [app1.app_ref]], [7, [app2.app_ref]]])
      expect(Document.first.planning_apps.count).to eq(2)
    end

    it 'adds the :page_link field to the join table' do
      app1, app2 = create(:planning_app), create(:planning_app)
      processor.link_apps(doc, [[1, [app1.app_ref]], [7, [app2.app_ref]]])
      expect(DB[:documents_planning_apps].select_map(:page_link)).to eq(["#{doc.url}#page=1", "#{doc.url}#page=7"])
    end

    it "returns array of doc app refs for any refs that can't be scraped/created" do
      app1, app2 = create(:planning_app), create(:planning_app)
      app1.app_ref = 'Z/2123/9999'
      expect(processor.link_apps(doc, [[1, [app1.app_ref]], [7, [app2.app_ref]]])).to eq(['Z/2123/9999'])
    end
  end

  context '#scrape_and_create_app' do
    it 'returns nil if an app cannot be scraped and created from the given app ref' do
      expect(processor.scrape_and_create_app('Z/2219/9999')).to be_nil
    end

    it 'returns the PlanningApp object if an app can be scraped and created from the given app ref' do
      expect(processor.scrape_and_create_app('P/2013/0548').class).to eq(PlanningApp)
    end
  end

  context '#parse_app_refs_from' do
    it 'returns a 2D array of page numbers and any app refs found on each page' do
      expect(processor.parse_app_refs_from(sample_doc_text)).to eq(PAGE_REFS)
    end
  end

  context 'create_docs' do
    it 'save documents in the variable "docs_with_urls"' do
      allow(processor).to receive(:docs_with_urls) { [build(:document), build(:document)] }
      processor.create_docs
      expect(DB[:documents].count).to eq 2
    end

    it 'returns 0 if "docs_with_urls" as no nils' do
      allow(processor).to receive(:docs_with_urls) { [build(:document), build(:document)] }
      expect(processor.create_docs).to eq 0
    end

    it 'returns 1 if "docs_with_urls" has a single nil, representing a broken document link' do
      allow(processor).to receive(:docs_with_urls) { [nil, build(:document)] }
      expect(processor.create_docs).to eq 1
    end
  end

end
