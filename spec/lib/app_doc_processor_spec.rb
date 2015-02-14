describe AppDocProcessor do

  processor = AppDocProcessor.new
  scraper = processor.scraper

  context '#new' do
    it 'should return an instance of the class' do
      expect(processor.class).to eq(AppDocProcessor)
    end
  end

  context '#s3_files' do
    it 'should return an array of the keys of existing S3 files' do
      expect(processor.s3_files.class).to eq(Array)
    end
  end

  context '#new_file_indices' do
    it 'returns an array of integers' do
      expect(processor.new_file_indices.all? { |e| e.kind_of?(Fixnum) }).to be_truthy
    end
  end

  context '#s3_object' do
    it 'should return an instance of Aws::S3::Object class' do
      expect(processor.s3_object('some_key').class).to eq(Aws::S3::Object)
    end
  end

  xcontext '#upload' do
    it 'should upload a file to S3 and return a pre-signed URL' do
      expect(lambda { URI.parse(processor.upload(0)) }).not_to raise_error
    end
  end

end
