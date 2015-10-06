describe S3storable do

  includer = class Includer; include S3storable; end
  # uri = 'http://www.gov.je/SiteCollectionDocuments/Planning%20and%20building/A%20PAC%2011%2006%202015.pdf'
  uri = 'http://www.gov.je/SiteCollectionDocuments/Planning%20and%20building/A%20-%20PAC%2017%2009%202015.pdf'
  duff_uri = 'http://www.gov.je/SiteCollectionDocuments/loadofoldbollocks.pdf'
  let(:helper) { includer.new }
  let(:example_key) { '150917_PAC_A'}

  context '#s3_file_keys' do
    it 'should return an non-zero list of the keys of existing S3 files' do
      expect(helper.s3_file_keys.size).to be > 0
    end
  end

  context '#s3_object' do
    it 'should return an instance of Aws::S3::Object class' do
      expect(helper.s3_object('some_key').class).to eq(Aws::S3::Object)
    end
  end

  context '#upload' do
    it 'should upload a file from a uri to S3 and return a valid URL' do
      expect(->{ URI.parse(helper.upload(uri, example_key)) }).not_to raise_error
    end

    it 'should raise FileUploadFailureError if a file cannot be uploaded' do
      expect(->{ URI.parse(helper.upload(duff_uri, example_key)) }).to raise_error("File at #{duff_uri} failed to upload")
    end

    it 'the URL should be public-readable' do
      url = helper.upload(uri, example_key)
      expect(->{ open(url) { |file| } }).not_to raise_error
    end
  end

end
