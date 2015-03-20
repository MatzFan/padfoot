describe S3storable do

  includer = class Includer; include S3storable; end
  uri = 'http://www.gov.je/SiteCollectionDocuments/Planning%20and%20building/M%20%20PAP%2020140724.pdf'
  let(:helper) { Includer.new }
  let(:example_key) { '140724_PAP_M'}

  context '#s3_file_keys' do
    it 'should return an array of the keys of existing S3 files' do
      expect(helper.s3_file_keys.class).to eq(Array)
    end
  end

  context '#s3_object' do
    it 'should return an instance of Aws::S3::Object class' do
      expect(helper.s3_object('some_key').class).to eq(Aws::S3::Object)
    end
  end

  context '#upload' do
    it "should upload a file from a uri to S3 and return a valid URL" do
      expect(->{ URI.parse(helper.upload(uri, example_key)) }).not_to raise_error
    end

    it "the URL should be public-readable" do
      url = helper.upload(uri, example_key)
      expect(->{ open(url) { |file| } }).not_to raise_error
    end
  end

end
