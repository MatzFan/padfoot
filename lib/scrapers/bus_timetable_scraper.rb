require 'mechanize'

class BusTimetableScraper

  ROOT = 'http://www.libertybus.je/'
  TIMETABLES_PAGE = 'routes_times/timetables'
  COORDS = [:Latitude, :Longitude]

  def initialize
    @agent = Mechanize.new
    @timetables_page = @agent.get(ROOT + TIMETABLES_PAGE)
  end

  def title
    @timetables_page.search("//div[@id='col-default-editor']/h2").text
  end

  def routes
    @timetables_page.search("//ul[@id='main-timetable-list']/li/a")
  end

  def route_links
    routes.map { |e| e.attribute('href').value.gsub('TRUE', 'FALSE') }
  end

   def route_names
    routes.map { |e| e.children[3].text }
  end

end
