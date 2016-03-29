require 'mechanize'

# pluggable json parser
class JSONParser < Mechanize::File
  attr_reader :json

  def initialize(uri = nil, response = nil, body = nil, code = nil)
    super(uri, response, body, code)
    @json = JSON.parse(body)
  end
end

# class to scrape a range of OBJECTID's from gis.digimap.gg
class DigimapScraper
  attr_reader :num_records

  DOMAIN = 'http://gis.digimap.je/ArcGIS/rest/services/'.freeze
  URL = ''.freeze # subclass overides
  FIELD_COLUMN_HASH = {}.freeze # subclass overides

  def initialize(min = 1, max = 1)
    raise ArgumentError, 'min < 1' if min < 1
    raise ArgumentError, 'min > max' if min > max
    @min = min
    @max = max
    @agent = Mechanize.new
    @agent.pluggable_parser['text/plain'] = JSONParser
    @form = form
  end

  def range
    "OBJECTID >= #{@min} AND OBJECTID <= #{@max}"
  end

  def form
    @agent.get(DOMAIN + self.class.const_get(:URL)).forms.first
  end

  def num_records
    json(true)['count'] # count_only true
  end

  def json(count_only = false)
    fill_form count_only
    @form.submit(@form.buttons[1]).json # POST button
  end

  def fill_form(count_only)
    @form.radiobutton_with(name: 'returnCountOnly').check if count_only
    @form.field_with(name: 'where').value = count_only ? 'OBJECTID > 0' : range
    @form.field_with(name: 'outFields').value = '*'
    @form.field_with(name: 'f').value = 'pjson'
  end

  def features
    json['features']
  end

  def attributes
    features.map { |e| e['attributes'] }
  end

  def data
    attributes.map { |hash| process(swap_keys(hash)) }
  end

  def swap_keys(hash)
    hash.map { |k, v| [self.class.const_get(:FIELD_COLUMN_HASH)[k], v] }.to_h
  end

  def process(hash) # can be overidden in subclass, but must call 'super'
    hash.each { |k, v| hash[k] = (v.is_a?(String) && v.empty? ? nil : v) }
  end
end
