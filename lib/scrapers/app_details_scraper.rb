require 'mechanize'

class AppDetailsScraper

  ROOT = 'https://www.mygov.je/'
  DETAILS_PAGE = '/Planning/Pages/PlanningApplicationDetail.aspx?s=1&r='

  attr_reader :agent, :app_ref, :details_title

  def initialize(app_ref)
    @agent = Mechanize.new
    @app_ref = app_ref
    @details_page = details_page
    @details_source = details_page.body
  end

  def details_title
    @details_title = details_page.title
  end

  def details_page
    # agent.agent.http.ssl_version = :TLSv1 # Lord knows why this needs to be set
    agent.get(ROOT + DETAILS_PAGE + app_ref)
  end

end
