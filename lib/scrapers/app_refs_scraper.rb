class AppRefsScraper # scrapes app refs for a given year


  ROOT = 'https://www.mygov.je/'
  CURL = 'curl -s -X POST -H "Content-Type: application/json" -d'
  URL = '"URL":'
  SITE = '"https://www.mygov.je//Planning/Pages/Planning.aspx"'
  COMMON = '"CommonParameters":'
  SEARCH = '"SearchParameters":'
  REQ_PAGE = '_layouts/15/PlanningAjaxServices/PlanningSearch.svc/Search'
  RESULT = 'ResultHTML'
  DELIM = 'href="https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&amp;r='

  attr_reader :year, :page_num

  def initialize(year)
    @year = year.to_s
    @page_num = 1
  end

  def app_refs_on_page(page_num)
    app_refs_array(page_num).map { |e| e.split('">')[0] }.uniq
  end

  def app_refs_array(page_num)
    source = json_for_page(page_num)
    app_arr = JSON.parse(source)[RESULT].split(DELIM)[1..-1]
  end

  def url_params
    URL + SITE
  end

  def common_params
    COMMON + '"|05|' + page_num.to_s + '||||"'
  end

  def search_params
    SEARCH + '"|1301||||0|All|All|01|01|' + year + '|' + '31|12|' + year + '"'
  end

  def params
    url_params + ',' + common_params + ',' + search_params
  end

  def json_for_page(page_num)
    cmd = CURL + " {'" + params + "}' " + ROOT + REQ_PAGE
    `#{cmd}`
  end

end
