require 'json'

class AppRefsScraper # scrapes app refs for a given year

  ROOT = 'https://www.mygov.je/'
  CURL = 'curl -s -X POST -H "Content-Type: application/json" -d'
  URL = '"URL":'
  SITE = '"https://www.mygov.je//Planning/Pages/Planning.aspx"'
  COMMON = '"CommonParameters":'
  SEARCH = '"SearchParameters":'
  REQ_PAGE = '_layouts/15/PlanningAjaxServices/PlanningSearch.svc/Search'
  RESULT = 'ResultHTML'
  HEADER = 'HeaderHTML'
  DETAILS_URL = '/Planning/Pages/PlanningApplicationDetail.aspx?s=1&amp;r='

  attr_reader :year, :start_page, :ref_num_string

  def initialize(year = Time.now.year, start_page = 1)
    @year = year.to_s
    @get_all = start_page.to_i < 0 ? true : false
    @start_page = start_page.to_i.abs # deal with -1
    @latest_app_num = latest_app_num
  end

  def latest_app_num
    PlanningApp.latest_app_num_for(year).to_s.rjust(4, "0") rescue '0000'
  end

  def refs
    refs = []
    (@start_page..num_pages).map do |page_num|
      logger.info "Getting apps for page: #{page_num}"
      refs += app_refs_on_page(page_num)
      return refs if !@get_all && include_latest_app_ref?(refs)
    end
    refs
  end

  def app_refs_on_page(page)
    app_refs_array(page).map { |e| e.split('">')[0] }.uniq
  end

  def num_apps # returns total number for the year
    JSON.parse(json_for_page(1))[HEADER].split[8].to_i
  end

  def num_pages
    (num_apps/10.0).ceil
  end

  def delimiter
    'href="' + ROOT + DETAILS_URL
  end

  def app_refs_array(page)
    JSON.parse(json_for_page(page))[RESULT].split(delimiter)[1..-1]
  end

  def url_params
    URL + SITE
  end

  def common_params(page)
    COMMON + '"|05|' + page.to_s + '||||"'
  end

  def search_params
    SEARCH + '"|1301||||0|All|All|01|01|' + year + '|' + '31|12|' + year + '"'
  end

  def params(page)
    url_params + ',' + common_params(page) + ',' + search_params
  end

  def json_for_page(page)
    cmd = CURL + " {'" + params(page) + "}' " + ROOT + REQ_PAGE
    `#{cmd}`
  end

  private

  def include_latest_app_ref?(refs)
    refs.any? { |r| r =~ /\/#{@year}\/#{@latest_app_num}$/ }
  end

end
