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

  attr_reader :year, :ref_num_string

  def initialize(year, ref_num_string = '0000') # Ruby 2.1 required keyword arg
    @year = year.to_s
    @ref_num_string = ref_num_string
  end

  def latest_refs
    refs_arr = []
    (1..3).collect do |page_num|
      refs_arr += app_refs_on_page(page_num)
      return refs_arr if refs_arr.any? { |ref| ref =~ /\/#{ref_num_string}$/ }
    end
  end

  def app_refs_on_page(page)
    app_refs_array(page).map { |e| e.split('">')[0] }.uniq
  end

  def num_apps # returns total number for the year
    JSON.parse(json_for_page(1))[HEADER].split[8].to_i
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

end
