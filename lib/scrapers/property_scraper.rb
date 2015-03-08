require 'mechanize'
require 'linguistics'

class JSONParser < Mechanize::File
  attr_reader :json

  def initialize(uri=nil, response=nil, body=nil, code=nil)
    super(uri, response, body, code)
    @json = JSON.parse(body)
  end
end

class IdsDontMatchError < StandardError; end

###############################################################################

class PropertyScraper

  Linguistics.use(:en) # for plural method


  DOMAIN = 'https://gps.digimap.gg/'
  URL = 'arcgis/rest/services/StatesOfJersey/JerseyPlanning/MapServer/0/query'

  KEYS = ['OBJECTID', 'guid_', 'Add1', 'Add2', 'Add3', 'Add4', 'Parish',
          'Postcode', 'UPRN', 'USRN', 'Property_Type', 'Address1', 'Vingtaine']

  FIELDS = ['where', 'text', 'objectIds', 'time', 'inSR', 'relationParam',
    'outFields', 'maxAllowableOffset', 'geometryPrecision', 'outSR',
    'orderByFields', 'groupByFieldsForStatistics', 'gdbVersion', 'geometry',
    'outStatistics', 'geometryType', 'spatialRel', 'f']

  RADIOS = ['returnGeometry', 'returnGeometry' ,'returnIdsOnly',
    'returnIdsOnly', 'returnCountOnly','returnCountOnly', 'returnZ', 'returnZ',
    'returnM', 'returnM', 'returnDistinctValues', 'returnDistinctValues']

  attr_reader :form

  def initialize(lower_id = 0, upper_id = 0)
    @lower_id, @upper_id = lower_id, upper_id
    @id_array = (@lower_id..@upper_id).to_a
    @agent = Mechanize.new
    @agent.pluggable_parser['text/plain'] = JSONParser # not 'application/json'..??
    @form = form
    validate
    @json = json
    setup_hash_key_methods
    setup_accessor_methods
    @features = features
    @atts = atts
  end

  def num_props
    form = Mechanize.new.get(DOMAIN + URL).forms.first
    form.fields[0].value = "UPRN > 0"
    form.radiobuttons[4].check # count only true
    parse_count(form.submit(form.buttons[1]).body)
  end

  def parse_count(page_text)
    page_text.split("\r\n").reverse.each do |string|
      (match = string.match(/^Count: (\d{5})$/)) ? (return match[1].to_i) : nil
    end
  end

  def validate
    raise Error unless @form.fields.map(&:name) == FIELDS &&
    @form.radiobuttons.map(&:name) == RADIOS
  end

  def form
    @agent.get(DOMAIN + URL).forms.first
  end

  def query_string
    "OBJECTID >= #{@lower_id} AND OBJECTID <= #{@upper_id}"
  end

  def set_query_params
    @form.fields[0].value = query_string # SQL 'WHERE' clause
    @form.fields[6].value = KEYS.join(',') # output fields
    # @form.fields[10].value = 'UPRN' # order by field
    @form.field_with(name: 'f').options[1].select # for JSON
  end

  def json
    set_query_params
    @form.submit(@form.buttons[1]).json
  end

  def setup_hash_key_methods
    (KEYS + %w(features attributes geometry x y)).each do |key|
      Hash.send(:define_method, key.downcase) { self[key] }
    end
  end

  def setup_accessor_methods # meta program accessor methods for all KEY fields
    KEYS.map(&:downcase).each do |key|
      self.class.send(:define_method, key.en.plural) { @atts.map(&key.to_sym) }
    end
    # and for geometry - :xs, :ys
    self.class.send(:define_method, 'xes') { geometry.map &:x }
    self.class.send(:define_method, 'yes') { geometry.map &:y }
  end

  def hash_key(key) # monkey patch Hash for each JSON key required
    Hash.send(:define_method, key.downcase) { self[key] }
  end

  def features
    @json['features']
  end

  def atts
    @features.map(&:attributes)
  end

  def geometry
    @features.map(&:geometry)
  end

  def coords
    xes.map { |x| Hash[x: x] }.zip(yes.map { |y| Hash[y: y] })
  end

  def data
    coords.zip(array_of_hashes).map(&:flatten).map { |arr| arr.inject &:merge }
  end

  def array_of_hashes
    KEYS[1..-1].inject(hashy(KEYS[0])) { |m, e| m.zip(hashy e) }.map &:flatten
  end

  def hashy(key)
    self.send(key.downcase.en.plural.to_sym).map do |e|
      Hash[dcase(key) => (e ? process(key, e) : nil)]
    end
  end

  def dcase(string)
    string.downcase.to_sym
  end

  def process(k, d) # data may be String or Fixnum
    return d if d.kind_of? Numeric
    return parish_num(d) if k == 'Parish'
    d.strip.empty? ? nil : d.strip
  end

  def parish_num(s)
    num = PARISHES.index(s.downcase.split(' ').map(&:capitalize).join(' '))
    num + 1 if num
  end

end
