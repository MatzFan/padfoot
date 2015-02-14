require 'open-uri'

class AppDocScraper

  ROOT = 'http://www.gov.je'
  URL = 'http://www.gov.je/PlanningBuilding/PublicPlanningMeetings/Pages/AgendasMinutes.aspx'
  PAP = 'PAP'
  MH = 'MM'
  PAP_TEXT = ['PAP', 'Panel'] # text in url which determines doc type is PAP
  MH_TEXT = ['MM', 'Ministerial'] # text in url which determines doc type is MH

  attr_reader :agent, :page, :uris

  def initialize
    @agent = Mechanize.new
    @page = page
    @uris = uris
  end

  def page
    agent.get(URL)
  end

  def links
    page.links.select { |link| link.text.include?('Download ') }
  end

  def uris
    links.map { |link| ROOT + link.uri.to_s }
  end

  def doc_names
    links.map { |link| link.text.encode }
  end

  def doc_types
    doc_names.map { |name| name.include?('agenda') ? 'A' : 'M' }
  end

  def doc_dates
    doc_names.map { |name| Date.parse(name).strftime("%d/%m/%Y").to_date }
  end

  def meet_types
    uris.map { |uri| pap?(uri) ? PAP : (mh?(uri) ? MH : '?') }
  end

  def pap?(uri)
    PAP_TEXT.any? { |text| File.basename(uri).include?(text) }
  end

  def mh?(uri)
    MH_TEXT.any? { |text| File.basename(uri).include?(text) }
  end

  def key(n)
    doc_dates[n].strftime("%y%m%d") + '_' + meet_types[n] + '_' + doc_types[n]
  end

  def upload(n)
    obj = s3_object(key(n))
    open(uris[n]) { |file| obj.upload_file(file) } # closes stream :)
    obj.presigned_url(:get)
  end

  def s3_object(object_key)
    Aws::S3::Object.new(bucket_name: BUCKET, key: object_key)
  end

end
