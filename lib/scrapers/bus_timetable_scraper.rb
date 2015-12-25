require 'mechanize'

class JavascriptVarsParser

  # RGX = /(var day.+;\n\s+var columns.+\n\s+var add.+)\n/
  RGX = /(var day.+;\n\s+var columns.+\n\s+var add.+)function load_maps/m
  CSS_COLOURS = {'dusk' => 'school', 'gold' => 'nonschool', 'sky' => 'friday' }

  def initialize(source)
    @source = source
  end

  def js_vars_for_special_days
    @source.match(RGX)[1].lines.map(&:strip).select { |e| e[0..2] == 'var' }
  end

  def route_tt_index(var)
    arr = var.split("'")[1].split('-')[0..1]
    [arr[0].downcase, arr[1].to_i]
  end

  def column_days(var)
    var.scan(/\d+/).map(&:to_i).zip(days(var))
  end

  def days(var)
    var.scan(/'([a-z]+)'/).flatten.map { |e| CSS_COLOURS[e] }
  end

  def special_days_data
    js_vars_for_special_days.each_slice(3).map do |a|
      [route_tt_index(a[0]), column_days(a[1])]
    end
  end

end


class BusTimetableScraper

  ROOT = 'http://www.libertybus.je'
  TIMETABLES_PAGE = '/routes_times/timetables'

  def initialize
    @agent = Mechanize.new
    @main_page = main_page
    @routes = routes
    @links = links
    @p = timetable_pages
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

  def timetable_pages
    (0...@links.size).map { |i| @agent.get(ROOT + @links[i]) }
  end

  def titles(i)
    @p[i].search("//div[@class='t-table']/h2").children.map(&:text).map &:strip
  end

  def bound_days(i)
    titles(i).map { |e| e.split(' - ')[-2..-1] }
  end

  def header_table_rows(i)
    @p[i]./(".//table[@class='headers']").map { |e| e./(".//tr") }
  end

  def bus_nums(i)
    times_table_rows(i).map(&:first).map { |e| e./(".//td").size - 4 }
  end

  def special_days(i)
    times_table_rows(i).map(&:first).map { |e| e./".//td[@class='dusk']" }
  end

  def code(row)
    row./(".//td/span").map(&:text).select { |e| e =~ /\d{4}/ }.first
  end

  def tt_codes(route_index, tt_index)
    header_table_rows(route_index)[tt_index].map { |row| code(row) }
  end

  def times_table_rows(i)
    @p[i]./(".//div[@class='scroll']/table").map { |e| e./(".//tr") }
  end

  def stop_times(i, tt_index, column)
    (0...num_stops(i, tt_index)).map do |row_num|
      [code(header_table_rows(i)[tt_index][row_num]), time(times_table_rows(i)[tt_index][row_num], column)]
    end
  end

  def buses(i)
    bus_nums(i).each_with_index.map do |num_buses, tt_index|
      (0...num_buses).map do |column|
        [rte_nums[i], *bound_days(i)[tt_index], stop_times(i, tt_index, column)]
      end
    end
  end

  def num_stops(i, tt_index)
    header_table_rows(i)[tt_index].size
  end

  # def tt_times(route_index, tt_index)
  #   (times_table_rows(route_index)[tt_index].map { |row| times(row) })
  # end

  # def times(row)
  #   row./(".//td")[3..-2].map(&:text).map { |e| e if e != ' - ' } # '-' to nils
  # end

  def time(row, column)
    time = row./(".//td")[column + 3].text
    time if time != ' - ' # '-' to nils
  end

  # def data(route_index, tt_index)
  #   tt_codes(route_index, tt_index).zip tt_times(route_index, tt_index)
  # end

  # def timetables(i)
  #   (0...titles(i).size).map { |x| [rte_nums[i], *bound_days(i)[x], data(i, x)] }
  # end

end
