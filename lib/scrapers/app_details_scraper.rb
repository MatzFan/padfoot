require 'mechanize'

class AppDetailsScraper

  ROOT = 'https://www.mygov.je/'
  DETAILS_PAGE = '/Planning/Pages/PlanningApplicationDetail.aspx?s=1&r='
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
  ID_DELIM = 'ctl00_lbl'

  attr_reader :agent, :app_ref, :details_page

  def initialize(app_ref)
    @agent = Mechanize.new
    @app_ref = app_ref
    @details_page = details_page
    return unless valid_details_page?
    @details_source = details_page.body
  end

  def valid_details_page?
    details_page.title.include?('Planning Application Detail')
  end

  def details_page
    agent.get(ROOT + DETAILS_PAGE + app_ref)
  end

  def details_data
    (0..1).map { |n| details_table(n).map { |i| i.text } }.flatten if t_valid?
  end

  def t_valid? # valid details table titles
    details_table_titles == DETAILS_TABLE_TITLES
  end

  def details_table(n) # app details are split over 2 tables with same class
    details_page.search(TABLE_CSS)[n].css('tr').css('td').css('span')
  end

  def details_table_titles
    (0..1).map { |n| details_table(n).map { |i| parse(i.attr('id')) } }.flatten
  end

  def parse(text)
    text.split(ID_DELIM).last
  end

end
