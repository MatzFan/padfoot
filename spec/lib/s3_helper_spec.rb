describe S3Helper do

  uri = AppDocScraper.new.uris[0]
  let(:helper) { S3Helper.new }
  let(:example_key) { '140724_PAP_M'}

  context '#new' do
    it 'should return an instance of the class' do
      expect(helper.class).to eq(S3Helper)
    end
  end

  context '#s3_files' do
    it 'should return an array of the keys of existing S3 files' do
      expect(helper.s3_files.class).to eq(Array)
    end
  end

  context '#s3_object' do
    it 'should return an instance of Aws::S3::Object class' do
      expect(helper.s3_object('some_key').class).to eq(Aws::S3::Object)
    end
  end

  context '#upload' do
    it 'should upload a file from a uri to S3 and return a pre-signed URL' do
      expect(lambda { URI.parse(helper.upload(uri, example_key)) }).not_to raise_error
    end
  end

end
