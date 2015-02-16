require 'open-uri'

class AppDocScraper

  ROOT = 'http://www.gov.je'
  URL = 'http://www.gov.je/PlanningBuilding/PublicPlanningMeetings/Pages/AgendasMinutes.aspx'
  TITLE_CSS = 'h2.govstyleElement-H3'
  PAP = 'PAP'
  MM = 'MM'
  PAP_TEXT = ['PAP', 'Panel'] # text in url which determines doc type is PAP
  MH_TEXT = ['MM', 'Ministerial'] # text in url which determines doc type is MH

  attr_reader :agent, :page, :table_years, :table_types, :table_links, :links,
  :num_docs, :table_link_names, :doc_types, :meet_types, :doc_dates

  def initialize
    @agent = Mechanize.new
    @page = page
    verify_structure
    @table_years = table_years
    @table_types = table_types
    @table_links = table_links
    @links = links
    @num_docs = links.count
    @table_link_names = table_link_names
    @doc_types = doc_types
    @meet_types = meet_types
    @doc_dates = doc_dates
  end

  def page
    agent.get(URL)
  end

  def table_titles
    page.search(TITLE_CSS).map(&:text).map { |s| zws(s) }.map(&:strip)
  end

  def zws(string) # pesky zero width spaces..
    string.gsub("\u200B", '')
  end

  def tables
    page.search('table')
  end

  def verify_structure
    raise error unless table_titles.count == tables.count
  end

  def table_years
    table_titles.map { |string| string.to_i if string.to_i != 0 }
  end

  def table_types
    table_titles.map { |s| s.include?('Panel') ? 'PAP' : s.include?('Ministerial') ? 'MM' : '?' }
  end

  def table_links # returns 2D array
    tables.map { |t| t.css('a').map { |link| ROOT + link.attr('href') } }
  end

  def links
    table_links.flatten
  end

  def meet_types
    @table_links.each_with_index.map do |t, i|
      @table_types[i] == '?' ? t.map { |e| type(e) } : t.map { |e| @table_types[i] }
    end.flatten
  end

  def type(link)
    pap?(link) ? PAP : (mm?(link) ? MM : '?')
  end

  def table_link_names
    tables.map { |t| t.css('a').map { |link| link.text.encode } }
  end

  def doc_types
    table_link_names.flatten.map { |name| name.include?('agenda') ? 'Agenda' : 'Minutes' }
  end

  def doc_dates
    @table_link_names.each_with_index.map do |t, i|
      t.map { |name| doc_date(name, @table_years[i]) }
    end.flatten
  end

  def doc_date(string, known_year = nil)
    date = Date.parse(string).strftime("%d/%m/%Y").to_date
    known_year ? Date.new(known_year, date.month, date.day) : date
  end

  def meet_data
    meet_types.zip(doc_dates).uniq.map { |e| [[:type, e[0]], [:date, e[1]]].to_h }
  end

  def pap?(uri)
    PAP_TEXT.any? { |text| File.basename(uri).include?(text) }
  end

  def mm?(uri)
    MH_TEXT.any? { |text| File.basename(uri).include?(text) }
  end

  def file_names
    (0...num_docs).map { |n| file_name(n) }
  end

  def file_name(n)
    "#{@doc_dates[n].strftime("%y%m%d")}_#{@meet_types[n]}_#{@doc_types[n][0]}" # [0] = first letter
  end

end
