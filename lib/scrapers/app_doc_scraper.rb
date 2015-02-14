require 'open-uri'

class AppDocScraper

  ROOT = 'http://www.gov.je'
  URL = 'http://www.gov.je/PlanningBuilding/PublicPlanningMeetings/Pages/AgendasMinutes.aspx'
  PAP = 'PAP'
  MH = 'MM'
  PAP_TEXT = ['PAP', 'Panel'] # text in url which determines doc type is PAP
  MH_TEXT = ['MM', 'Ministerial'] # text in url which determines doc type is MH

  attr_reader :agent, :page, :uris, :num_docs, :doc_types, :meet_types, :doc_dates

  def initialize
    @agent = Mechanize.new
    @page = page
    @uris = uris
    @num_docs = uris.count
    @doc_types = doc_types
    @meet_types = meet_types
    @doc_dates = doc_dates
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
    doc_names.map { |name| name.include?('agenda') ? 'Agenda' : 'Minutes' }
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

  def file_names
    (0...num_docs).map { |n| file_name(n) }
  end

  def file_name(n)
    "#{@doc_dates[n].strftime("%y%m%d")}_#{@meet_types[n]}_#{@doc_types[n][0]}" # [0] = first letter
  end

end
