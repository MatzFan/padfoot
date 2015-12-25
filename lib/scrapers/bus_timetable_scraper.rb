require 'mechanize'

class JavascriptVarsParser

  # RGX = /(var day.+;\n\s+var columns.+\n\s+var add.+)\n/
  RGX = /(var day.+;\n\s+var columns.+\n\s+var add.+)function load_maps/m
  CSS_COLOURS = {'dusk' => 'School Days Only',
                 'gold' => 'Non-School Days Only',
                 'sky' => 'Fridays Only' }

  def initialize(source, route_nums, col_offset)
    @source = source
    @route_nums = route_nums
    @col_offset = col_offset
  end

  def js_vars_for_special_days
    @source.match(RGX)[1].lines.map(&:strip).select { |e| e[0..2] == 'var' }
  end

  def route_tt_index(var)
    arr = var.split("'")[1].split('-')[0..1]
    [@route_nums.index(arr[0].downcase), arr[1].to_i]
  end

  def column_days(var)
    var.scan(/\d+/).map(&:to_i).map { |n| n - @col_offset }.zip(days(var))
  end

  def days(var)
    var.scan(/'([a-z]+)'/).flatten.map { |e| day_from_css(e) }
  end

  def day_from_css(klass)
    raise ArgumentError, "New JS CSS class: #{klass}" unless CSS_COLOURS[klass]
    CSS_COLOURS[klass]
  end

  def special_days_data
    js_vars_for_special_days.each_slice(3).map do |a|
      [route_tt_index(a[0]), column_days(a[1])]
    end.select { |e| e[0][0] } # rejects routes which no longer exist
  end

end


class BusTimetableScraper

  ROOT = 'http://www.libertybus.je'
  TIMETABLES_PAGE = '/routes_times/timetables'
  COL_OFFSET = 3 # offset of the first times column in a timetable

  def initialize
    @agent = Mechanize.new
    @main_page = main_page
    @routes = routes
    @route_nums = route_nums
    @parser = parser
    @special_days = special_days
    @links = links
    @p = timetable_pages
  end

  def main_page
    @agent.get(ROOT + TIMETABLES_PAGE)
  end

  def parser
    JavascriptVarsParser.new(@main_page.body, @route_nums, COL_OFFSET)
  end

  def special_days
    @parser.special_days_data
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

  def route_nums
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

  def bounds(i)
    titles(i).map { |e| e.split(' - ')[-2] }
  end

  def days(i)
    titles(i).map { |e| e.split(' - ').last }
  end

  def header_trs(i)
    @p[i]./(".//table[@class='headers']").map { |e| e./(".//tr") }
  end

  def bus_nums(i)
    times_trs(i).map(&:first).map { |e| e./(".//td").size - COL_OFFSET - 1 }
  end

  def code(row)
    row./(".//td/span").map(&:text).select { |e| e =~ /\d{4}/ }.first
  end

  def tt_codes(route_index, tt_index)
    header_trs(route_index)[tt_index].map { |row| code(row) }
  end

  def times_trs(i)
    @p[i]./(".//div[@class='scroll']/table").map { |e| e./(".//tr") }
  end

  def num_stops(i, tt_index)
    header_trs(i)[tt_index].size
  end

  def time(row, column)
    time = row./(".//td")[column + COL_OFFSET].text
    time if time != ' - ' # '-' to nils
  end

  def stop_times(i, tt_index, column)
    (0...num_stops(i, tt_index)).map do |row_num|
      [code(header_trs(i)[tt_index][row_num]), time(times_trs(i)[tt_index][row_num], column)]
    end
  end

  def special_day(i, tt_index, col)
    s = @special_days.select { |e| e[0][0] == i && e[0][1] == tt_index }
    s.each { |a| a.last.each { |a| return a[1] if a[0] == col } } if !s.empty?
    nil
  end

  def buses(i)
    bus_nums(i).each_with_index.map do |num_buses, tt_index|
      (0...num_buses).map do |column|
        [@route_nums[i], bounds(i)[tt_index], (special_day(i, tt_index, column) || days(i)[tt_index]), stop_times(i, tt_index, column)]
      end
    end
  end

end
