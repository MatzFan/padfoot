require 'mechanize'

class BusTimetableScraper

  ROOT = 'http://www.libertybus.je'
  TIMETABLES_PAGE = '/routes_times/timetables'

  def initialize
    @agent = Mechanize.new
    @timetables_page = @agent.get(ROOT + TIMETABLES_PAGE)
    @routes = routes
    @links = links
  end

  def main_title
    @timetables_page.search("//div[@id='col-default-editor']/h2").text
  end

  def routes
    @timetables_page.search("//ul[@id='main-timetable-list']/li/a")
  end

  def links
    @routes.map { |e| e.attribute('href').value.gsub('TRUE', 'FALSE') }
  end

  def names
    @routes.map { |e| e.children[3].text }
  end

  def timetable_page(index)
    @agent.get(ROOT + @links[index])
  end

  def timetable_titles(page)
    page.search("//div[@class='t-table']/h2").children.map(&:text).map &:strip
  end

  def header_tables(page)
    page.search("//div[@class='t-table']/table")
  end

  def times_tables(page)
    page.search("//div[@class='t-table']/div[@class='scroll']/table")
  end

end
