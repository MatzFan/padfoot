require_relative 's3_storable'
require 'open-uri'

class AppDocProcessor
  include S3storable

  attr_reader :scraper, :new_data, :new_doc_link_data, :link_count

  def initialize
    @scraper = AppDocScraper.new
    @new_data = new_data
    @new_doc_link_data = new_doc_link_data
    @link_count = []
  end

  def create_meetings
    scraper.meet_data.each { |hash| Meeting.find_or_create(hash) }
  end

  def new_data # data-pairs is 2D array of doc/meeting data hash pairs
    scraper.data_pairs.reject do |arr|
      s3_file_keys.any? { |f| arr[0][:name] == f }
    end
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
    docs_with_meeting_ids.each_with_index.map do |doc, i|
      begin
        doc.url = upload(links[i], doc.name) # upload returns the public url
        doc
      rescue # deals with 404 error for broken links
        nil
      end
    end
  end

  def create_docs
    docs_with_urls.compact.each &:save
    docs_with_urls.count - docs_with_urls.compact.count
  end

  def create_doc_app_ref_links
    Document.unlinked_docs.map do |doc|
      link_apps(doc, page_app_refs_in(doc))
    end.flatten
  end

  def link_apps(doc, page_refs)
    page_nums = page_refs.map(&:first)
    refs = page_refs.map(&:last)  # refs is 2D array
    page_nums.each_with_index.map do |page_num, i|
      refs[i].map do |ref|
        app = PlanningApp[ref] || scrape_and_create_app(ref) # try to create if not in DB
        app ? add_app_to_doc(app, doc, page_num) : ref # return ref if app can't be scraped/created
      end
    end.flatten.compact
  end

  def add_app_to_doc(app, doc, page_num)
    if !doc.planning_apps.include?(app)
      doc.add_planning_app(app, page_link: "#{doc.url}#page=#{page_num}")
      app.save # needed to update :list_app_meetings field in PlanningApp
      nil
    end
  end

  def scrape_and_create_app(ref)
    data = AppDetailsScraper.new([ref]).data[0]
    data == {} ? nil : PlanningApp.create(data)
  end

  def page_app_refs_in(doc)
    open('temp_pdf', 'wb') { |file| file << open(doc.url).read }
    text = `pdftotext -enc UTF-8 temp_pdf -`
    File.delete('temp_pdf')
    parse_app_refs_from(text)
  end

  def parse_app_refs_from(doc_text)
    doc_text.split("\u000C").each_with_index.map do |page_text, i|
      [i + 1, refs_in_page(page_text)] # add 1 as pdf page links index from 1
    end.reject { |arr| arr.last == [] }
  end

  def refs_in_page(page_text)
    regex = '(?:\d{1,2}. )?([A-Z]{1,3}\/(19|20)\d{2}\/\d{4})'
    lines = page_text.split("\n")
    first = lines.map { |t| t.scan(/^#{regex}/).map(&:first) rescue nil }.compact.flatten
    last = lines.map { |t| t.scan(/#{regex}$/).map(&:first) rescue nil }.compact.flatten
    (first + last).uniq
  end

end
