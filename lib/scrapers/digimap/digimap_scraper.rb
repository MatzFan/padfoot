require 'mechanize'

# pluggable json parser
class JSONParser < Mechanize::File
  attr_reader :json

  def initialize(uri = nil, response = nil, body = nil, code = nil)
    super(uri, response, body, code)
    @json = JSON.parse(body)
    # @features = features
  end
end

# class to scrape gis.digimap.gg
class DigimapScraper
  attr_reader :num_records

  DOMAIN = 'http://gis.digimap.je/ArcGIS/rest/services/'.freeze
  URL = ''.freeze # subclass overides
  KEYS = [].freeze # subclass overides

  def initialize(min = 1, max = 1)
    raise ArgumentError, 'min < 1' if min < 1
    raise ArgumentError, 'min > max' if min > max
    @min = min
    @max = max
    @range = range
    @agent = Mechanize.new
    @agent.pluggable_parser['text/plain'] = JSONParser
    @form = form
    @json = json
    @features = features
  end

  # def data
  # end

  def range
    "OBJECTID >= #{@min} AND OBJECTID <= #{@max}"
  end

  def form
    @agent.get(DOMAIN + self.class.const_get(:URL)).forms.first
  end

  def num_records
    json(true)['count']
  end

  def json(count_only = false)
    fill_form count_only
    @form.submit(@form.buttons[1]).json # POST button
  end

  def fill_form(count_only)
    @form.radiobutton_with(name: 'returnCountOnly').check if count_only
    @form.field_with(name: 'where').value = count_only ? 'OBJECTID > 0' : @range
    @form.field_with(name: 'outFields').value = '*'
    @form.field_with(name: 'f').value = 'pjson'
  end

  def features
    @json['features']
  end

  def geometry
    @features.map { |e| e['geometry'] }
  end

  def attributes
    @features.map { |e| e['attributes'] }
  end
end
