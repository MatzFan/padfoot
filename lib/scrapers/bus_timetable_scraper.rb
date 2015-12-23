require 'mechanize'

class BusTimetableScraper

  ROOT = 'http://www.libertybus.je'
  TIMETABLES_PAGE = '/routes_times/timetables'

  def initialize
    @agent = Mechanize.new
    @main_page = main_page
    @routes = routes
    @links = links
    @pages = pages
  end

  def main_page
    @agent.get(ROOT + TIMETABLES_PAGE)
  end

  def main_title
    @main_page.search("//div[@id='col-default-editor']/h2").text
  end

  def routes
    @main_page.search("//ul[@id='main-timetable-list']/li/a")
  end

  def links
    @routes.map { |e| e.attribute('href').value.gsub('TRUE', 'FALSE') }
  end

  def rte_nums
    @routes.map { |e| e.children[1].children.text }
  end

  def route_names
    @routes.map { |e| e.children[3].text }
  end

  def pages
    (0...@links.size).map { |i| @agent.get(ROOT + @links[i]) }
  end

  def titles(i)
    pages[i].search("//div[@class='t-table']/h2").children.map(&:text).map &:strip
  end

  def days(i)
    return 'Weekdays' if i < 2
    return 'Saturday' if i < 4
    return 'Sunday' if i < 6
    raise ArgumentError, 'More than 6 timetables for a route'
  end

  def dir(i) # Outbound or Inbound
    i.even? ? 'Out' : 'In'
  end

  def header_table_rows(i)
    pages[i]./(".//table[@class='headers']").map { |e| e./(".//tr") }
  end

  def code(row)
    row./(".//td/span").map(&:text).select { |e| e =~ /\d{4}/ }
  end

  def tt_codes(route_index, tt_index)
    header_table_rows(route_index)[tt_index].map { |row| code(row) }
  end

  def times_table_rows(i)
    pages[i]./(".//div[@class='scroll']/table").map { |e| e./(".//tr") }
  end

  def tt_times(route_index, tt_index)
    (times_table_rows(route_index)[tt_index].map { |row| times(row) })
  end

  def times(row)
    row./(".//td")[3..-2].map &:text
  end

  def data(route_index, tt_index)
    tt_codes(route_index, tt_index).flatten.zip tt_times(route_index, tt_index)
  end

  def timetables(i)
    (0...titles(i).size).map { |x| [rte_nums[i], dir(x), days(x), data(i, x)] }
  end

end
