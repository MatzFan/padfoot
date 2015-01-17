require 'mechanize'

class AppDetailsScraper

  ROOT = 'https://www.mygov.je/'
  DETAILS_PAGE = 'Planning/Pages/PlanningApplicationDetail.aspx?s=1&r='
  DATES_PAGE = 'Planning/Pages/PlanningApplicationTimeline.aspx?s=1&r='
  TABLE_CSS = ".//table[@class='pln-searchd-table']"
  ID_DELIM = 'ctl00_lbl'
  COORDS = [:Latitude, :Longitude]

  attr_reader :agent, :app_ref, :details_page, :dates_page, :has_valid_ref

  def initialize(app_ref)
    @agent = Mechanize.new
    @app_ref = app_ref
    @details_page = details_page
    @dates_page = dates_page
    @has_valid_ref = valid?(details_page) && valid?(dates_page)
  end

  def valid?(page) # incorrect app refs yield 'error' in title
    page.title.include?('Application')
  end

  def details_page
    agent.get(ROOT + DETAILS_PAGE + app_ref)
  end

  def dates_page
    agent.get(ROOT + DATES_PAGE + app_ref)
  end

  def app_details
    det_t_ok? ? (0..1).map { |n| details_table(n).map { |i| clean(i.text) } }.flatten : {}
  end

  def clean(text)
    text.strip.squeeze(' ') # removes all repeated spaces :)
  end

  def details_hash
    Hash[const(:DETAILS_FIELDS).zip(app_details)].reject { |k,v| v.empty? }
  end

  def const(sym)
    PlanningApp.const_get(sym)
  end

  def app_dates # array of the 7 dates, formatted appropriately
    dat_t_ok? ? dates_table.map { |i| format_date(i.text) } : {}
  end

  def format_date(string)
    DateTime.parse(string).to_date rescue nil # returns nil for non-dates
  end

  def dates_hash
    Hash[const(:DATES_FIELDS).zip(app_dates)].reject { |k,v| v.nil? }
  end

  def data_hash # hash of the application table_titles: data, less empty values
    details_hash.merge(coords_hash).merge(dates_hash).reject { |k,v| v.nil? }
  end

  def det_t_ok? # valid details table titles?
    details_table_titles == const(:DETAILS_TABLE_TITLES)
  end

  def dat_t_ok? # valid dates table titles?
    dates_table_titles == const(:DATES_TABLE_TITLES)
  end

  def details_table(n) # app details are split over 2 tables with same class
    details_page.search(TABLE_CSS)[n].css('tr').css('td').css('span')
  end

  def dates_table
    dates_page.search(TABLE_CSS).css('tr').css('td').css('span')
  end

  def details_table_titles
    (0..1).map { |n| details_table(n).map { |i| parse(i.attr('id')) } }.flatten
  end

  def dates_table_titles
    dates_table.map { |i| parse(i.attr('id')) }
  end

  def parse(text)
    text.split(ID_DELIM).last
  end

  def coords
    COORDS.map { |coord| parse_coord(details_page.body, coord.to_s).to_f }
  end

  def coords_hash # validates latitude
    coords[0] > 48.6 ? Hash[COORDS.map { |c| c.downcase }.zip(coords)] : {}
  end

  def parse_coord(source, coord)
    source.split('window.MapCentre' + coord + ' = ').last.split(';').first
  end

end
