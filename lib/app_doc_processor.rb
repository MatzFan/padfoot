require_relative 's3_helper'

class AppDocProcessor
  include S3Helper

  attr_reader :scraper, :new_data, :new_doc_link_data

  def initialize
    @scraper = AppDocScraper.new
    @new_data = new_data
    @new_doc_link_data = new_doc_link_data
  end

  def create_meetings
    scraper.meet_data.each { |hash| Meeting.find_or_create(hash) }
  end

  def new_data # data-pairs is 2D array of doc/meetign data hash pairs
    scraper.data_pairs.reject { |arr| s3_file_keys.any? { |f| arr[0][:name] == f } }
  end

  def new_doc_link_data
    @new_data.map(&:first).flatten
  end

  def new_doc_data
    new_doc_link_data.map { |hash| hash.reject { |k,v| k == :link } }
  end

  def links
    new_doc_link_data.map { |hash| hash.select { |k,v| k == :link }[:link] }
  end

  def meeting_data
    @new_data.map(&:last).flatten
  end

  def new_docs #
    new_doc_data.map { |hash| Document.new(hash) }
  end

  def docs_with_meeting_ids
    new_docs.each_with_index.map do |doc, i|
      doc[:meeting_id] = meeting_id(i)
      doc
    end
  end

  def meeting_id(index)
    Meeting.where(meeting_data[index]).first.id
  end

  def docs_with_urls
    docs_with_meeting_ids.each_with_index do |doc, i|
      doc.url = upload(links[i], doc.name) # upload returns the pre-signed url
      doc
    end
  end

  def create_docs
    docs_with_urls.each &:save
  end

end
