require 'mechanize'

class AppDetailsScraper

  ROOT = 'https://www.mygov.je/'
  DETAILS_PAGE = 'Planning/Pages/PlanningApplicationDetail.aspx?s=1&r='
  DATES_PAGE = 'Planning/Pages/PlanningApplicationTimeline.aspx?s=1&r='
  TABLE_CSS = ".//table[@class='pln-searchd-table']"
  DETAILS_TABLE_TITLES = ["Reference",
                          "Category",
                          "Status",
                          "Officer",
                          "Applicant",
                          "Description",
                          "ApplicationAddress",
                          "RoadName",
                          "Parish",
                          "PostCode",
                          "Constraints",
                          "Agent"]
  DATES_TABLE_TITLES = ['ValidDate',
                        'AdvertisedDate',
                        'endpublicityDate',
                        'SitevisitDate',
                        'CommitteeDate',
                        'Decisiondate',
                        'Appealdate']
  ID_DELIM = 'ctl00_lbl'
  COORDS = ['Latitude', 'Longitude']

  attr_reader :agent, :app_ref, :details_page, :dates_page

  def initialize(app_ref)
    @agent = Mechanize.new
    @app_ref = app_ref
    @details_page = details_page
    @dates_page = dates_page
    return nil unless valid?(details_page) && valid?(dates_page)
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
    (0..1).map { |n| details_table(n).map { |i| i.text } }.flatten if det_t_ok?
  end

  def app_dates # array of the 7 dates
    dates_table.map { |i| format(i.text) } if dat_t_ok?
  end

  def app_data # array of the 15 application details, incl. coords
    app_details + app_coords
  end

  def det_t_ok? # valid details table titles?
    details_table_titles == DETAILS_TABLE_TITLES
  end

  def dat_t_ok? # valid dates table titles?
    dates_table_titles == DATES_TABLE_TITLES
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

  def app_coords
    COORDS.map { |coord| parse_coord(details_page.body, coord).to_f }
  end

  def parse_coord(source, coord)
    source.split('window.MapCentre' + coord + ' = ').last.split(';').first
  end

end
