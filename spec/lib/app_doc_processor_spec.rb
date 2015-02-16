describe AppDocProcessor do

  processor = AppDocProcessor.new
  scraper = processor.scraper

  context '#new' do
    it 'should return an instance of the class' do
      expect(processor.class).to eq(AppDocProcessor)
    end
  end

  context '#scraped_doc_data' do
    it 'returns a 2D array of document data' do
      expect(processor.scraped_doc_data[0].class).to eq(Array)
    end
  end

  context '#new_doc_data' do
    it 'returns a 2D array of data for new documents (not yet in S3)' do
      pp processor.new_doc_data
      expect(processor.new_doc_data.count).to eq(26)
    end
  end

end
