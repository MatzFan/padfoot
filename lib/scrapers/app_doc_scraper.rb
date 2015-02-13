class AppDocScraper

  ROOT = 'http://www.gov.je'
  URL = 'http://www.gov.je/PlanningBuilding/PublicPlanningMeetings/Pages/AgendasMinutes.aspx'
  PAP = 'Panel'
  MH = 'Ministerial'
  PAP_TEXT = ['PAP', 'Panel'] # text in url which determines doc type is PAP
  MH_TEXT = ['MM', 'Ministerial'] # text in url which determines doc type is MH

  attr_reader :agent

  def initialize
    @agent = Mechanize.new
  end

  def page
    agent.get(URL)
  end

  def doc_links
    page.links.select { |link| link.text.include?('Download ') }
  end

  def doc_uris
    doc_links.map { |link| ROOT + link.uri.to_s }
  end

  def doc_names
    doc_links.map { |link| link.text.encode }
  end

  def doc_types
    doc_names.map { |name| name.include?('agenda') ? 'Agenda' : 'Minutes' }
  end

  def doc_dates
    doc_names.map { |name| Date.parse(name).strftime("%d/%m/%Y").to_date }
  end

  def meeting_types
    doc_uris.map { |uri| pap_type?(uri) ? PAP : (mh_type?(uri) ? MH : '?') }
  end

  def pap_type?(uri)
    PAP_TEXT.any? { |text| File.basename(uri).include?(text) }
  end

  def mh_type?(uri)
    MH_TEXT.any? { |text| File.basename(uri).include?(text) }
  end

end
