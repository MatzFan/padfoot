class AppDocProcessor

  attr_reader :scraper

  def initialize
    @scraper = AppDocScraper.new
    @new_doc_data = new_doc_data
  end

  def scraped_doc_data
    scraper.file_names.zip(scraper.uris)
  end

  def s3_doc_names
    S3Helper.new.s3_files
  end

  def new_doc_data
    scraped_doc_data.reject { |arr| s3_doc_names.any? { |f| arr[0] == f } }
  end

end
