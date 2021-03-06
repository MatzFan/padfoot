require 'mechanize'

# Scrapes application details
class AppDetailsScraper
  UA = 'Mozilla/5.0 (Windows NT 6.1; rv:52.0) Gecko/20100101 Firefox/52.0'.freeze
  HEADERS = { 'User-Agent' => UA }.freeze
  MIS = 'Application number is missing from the request or was not found'.freeze
  ROOT = 'https://www.gov.je/citizen/Planning/Pages/'.freeze
  FEDAUTH = 'FedAuth'.freeze
  DETAILS_PAGE = 'PlanningApplicationDetail.aspx?s=1&r='.freeze
  DATES_PAGE = 'PlanningApplicationTimeline.aspx?s=1&r='.freeze
  CSS = ".//table[@class='pln-searchd-table']".freeze
  TT = '_table_titles'.freeze
  ID_DELIM = 'ctl00_lbl'.freeze
  COORDS = %i[Latitude Longitude].freeze
  LAT = 48.6 # minimum value for valid coords

  attr_reader :agent, :app_refs, :num_refs, :det_pages, :dat_pages

  def initialize(*app_refs)
    @agent = Mechanize.new.tap { |agent| agent.request_headers = HEADERS } # tap
    @app_refs = app_refs.flatten # an array
    set_fed_auth_cookie
    @num_refs = @app_refs.length
    @det_pages = pages('DETAILS_PAGE').map(&validate)
    @dat_pages = pages('DATES_PAGE').map(&validate)
    return if num_refs != det_pages.size || num_refs != dat_pages.size
  end

  def set_fed_auth_cookie
    agent.get(ROOT + DETAILS_PAGE + app_refs.first)
    agent.cookie_jar << agent.cookies.select { |c| c.name == FEDAUTH }.first
  end

  def validate
    proc { |page| page unless page.body.include? MIS } # invalid pages => nil's
  end

  def pages(type)
    app_refs.map { |ref| agent.get(ROOT + self.class.const_get(type) + ref) }
  end

  def app_details(i)
    if table_ok?(i, 'details')
      (0..1).map { |n| det_table(i, n).map { |e| get_text(e) } }.flatten
    else
      {}
    end
  end

  def get_text(e)
    e.text.empty? ? nil : e.text.strip.squeeze(' ') # removes repeated spaces
  end

  def details_hash(i)
    Hash[const(:DETAILS_FIELDS).zip(app_details(i))]
  end

  def const(sym)
    PlanningApp.const_get(sym)
  end

  def app_dates(i) # array of the 7 dates, formatted appropriately
    table_ok?(i, 'dates') ? dates_table(i).map { |e| format_date(e.text) } : {}
  end

  def format_date(string)
    DateTime.parse(string).to_date rescue nil # returns nil for non-dates
  end

  def dates_hash(i)
    Hash[const(:DATES_FIELDS).zip(app_dates(i))]
  end

  def data_hash(i) # hash of the application table_titles: data
    details_hash(i).merge(coords_hash(i)).merge(dates_hash(i))
  end

  def data
    (0...num_refs).map { |i| det_pages[i] && dat_pages[i] ? data_hash(i) : {} }
  end

  def err(i, type)
    "Bad #{type} table structure for #{app_refs[i]}"
  end

  def table_ok?(i, type)
    raise err(i, type) if send("#{type + TT}", i) != const("#{(type + TT).upcase}")
    return true
  end

  def det_table(i, n) # app details are split over 2 tables with same class
    det_pages[i].search(CSS)[n].css('tr').css('td').css('span') rescue []
  end

  def dates_table(i)
    dat_pages[i].search(CSS).css('tr').css('td').css('span') rescue []
  end

  def details_table_titles(i)
    (0..1).map { |n| det_table(i, n).map { |e| parse(e.attr('id')) } }.flatten
  end

  def dates_table_titles(i)
    dates_table(i).map { |e| parse(e.attr('id')) }
  end

  def parse(text)
    text.split(ID_DELIM).last
  end

  def coords(i)
    COORDS.map { |coord| parse_coord(det_pages[i].body, coord.to_s).to_f }
  end

  def coords_hash(r)
    coords(r)[0] > LAT ? Hash[COORDS.map(&:downcase).zip(coords(r))] : {}
  end

  def parse_coord(source, coord)
    source.split('window.MapCentre' + coord + ' = ').last.split(';').first
  end
end
