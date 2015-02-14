class AppDocProcessor

  attr_reader :s3_files, :scraper, :scraped_files

  def initialize
    @s3_files = s3_files
    @scraper = AppDocScraper.new
    @scraped_files = scraped_files
  end

  def s3_files
    S3.list_objects(bucket: BUCKET).map { |r| r.contents.map(&:key) }.flatten #flatten for single file case
  end

  def upload(n)
    obj = s3_object(scraper.file_names[0])
    open(scraper.uris[n]) { |file| obj.upload_file(file) } # closes stream :)
    obj.presigned_url(:get)
  end

  def s3_object(object_key)
    Aws::S3::Object.new(bucket_name: BUCKET, key: object_key)
  end

  def scraped_files
    scraper.file_names
  end

  def new_file_indices
    (0...scraped_files.count).to_a.reject { |i| s3_files.any? { |f| scraped_files[i] == f } }
  end

end
