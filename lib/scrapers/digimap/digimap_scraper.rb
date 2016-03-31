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
  class InvalidParserError < StandardError; end

  DOMAIN = 'http://gis.digimap.je/ArcGIS/rest/services/'.freeze
  JSON = '?f=json&pretty=true'.freeze
  URL = ''.freeze # subclass overides
  FIELD_COLUMN_HASH = {}.freeze # subclass overides
  F = 'f'.freeze
  WHERE = 'where'.freeze
  OUT_FIELDS = 'outFields'.freeze
  RETURN_COUNT_ONLY = 'returnCountOnly'.freeze

  def initialize(min = 1, max = 1)
    raise ArgumentError, 'min < 1' if min < 1
    raise ArgumentError, 'min > max' if min > max
    @min = min
    @max = max
    @url = DOMAIN + self.class.const_get(:URL)
    @agent = Mechanize.new
    @agent.pluggable_parser['text/plain'] = JSONParser
    @form = form
    validate_fields
    validate_form
  end

  def fields_from_constant
    self.class.const_get(:FIELD_COLUMN_HASH).keys
  end

  def validate_fields
    raise InvalidParserError unless fields == fields_from_constant
  end

  def fields
    reject_shape @agent.get(@url + JSON).json['fields'].map { |e| e['name'] }
  end

  def validate_form
    raise InvalidParserError unless form_fields_ok?
    raise InvalidParserError unless form_radios_ok?
  end

  def form_fields_ok?
    [F, WHERE, OUT_FIELDS].all? { |s| @form.fields.map(&:name).include? s }
  end

  def form_radios_ok?
    @form.radiobuttons.map(&:name).include? RETURN_COUNT_ONLY
  end

  def range
    "OBJECTID >= #{@min} AND OBJECTID <= #{@max}"
  end

  def form
    @agent.get(@url + '/query').forms.first
  end

  def reject_shape(arr)
    arr.reject { |e| e == 'Shape' }
  end

  def num_records
    json(true)['count'] # count_only true
  end

  def json(count_only = false)
    fill_form count_only
    @form.submit(@form.buttons[1]).json # POST button
  end

  def fill_form(count_only)
    @form.radiobutton_with(name: RETURN_COUNT_ONLY).check if count_only
    @form.field_with(name: WHERE).value = count_only ? 'OBJECTID > 0' : range
    @form.field_with(name: OUT_FIELDS).value = '*'
    @form.field_with(name: F).value = 'pjson'
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
