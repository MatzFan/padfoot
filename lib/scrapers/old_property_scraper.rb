require 'mechanize'
require 'linguistics'

class JSONParser < Mechanize::File
  attr_reader :json

  def initialize(uri=nil, response=nil, body=nil, code=nil)
    super(uri, response, body, code)
    @json = JSON.parse(body)
  end
end

class UprnsDontMatchError < StandardError; end

###############################################################################

class OldPropertyScraper

  Linguistics.use(:en) # for plural method

  URL = 'https://gps.digimap.gg/arcgis/rest/services/StatesOfJersey/JerseyPlanning/MapServer/0/query'

  KEYS = %w(OBJECTID Shape guid_ logicalstatus Add1 Add2 Add3 Add4 Parish Postcode Island UPRN USRN Property_Type Address1 Easting Northing Vingtaine Updated)

  FIELDS = ['where', 'text', 'objectIds', 'time', 'inSR', 'relationParam',
    'outFields', 'maxAllowableOffset', 'geometryPrecision', 'outSR',
    'orderByFields', 'groupByFieldsForStatistics', 'gdbVersion', 'geometry',
    'outStatistics', 'geometryType', 'spatialRel', 'f']

  RADIOS = ['returnGeometry', 'returnGeometry' ,'returnIdsOnly',
    'returnIdsOnly', 'returnCountOnly','returnCountOnly', 'returnZ', 'returnZ',
    'returnM', 'returnM', 'returnDistinctValues', 'returnDistinctValues']

  attr_reader :form

  def initialize(*uprn_list)
    @uprn_list = uprn_list.flatten
    raise ArgumentError unless @uprn_list.dup.sort == @uprn_list
    @agent = Mechanize.new
    @agent.pluggable_parser['text/plain'] = JSONParser # not 'application/json'..??
    @form = form
    validate
    @json = json
    setup_hash_key_methods
    setup_accessor_methods
    @features = features
  end

  def num_props
    form = Mechanize.new.get(URL).forms.first
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
    @agent.get(URL).forms.first
  end

  def set_query_params
    @form.fields[0].value = query_string # SQL 'WHERE' clause
    @form.fields[6].value = KEYS.join(',') # output fields
    @form.fields[10].value = 'UPRN' # order by field
    @form.field_with(name: 'f').options[1].select # for JSON
  end

  def query_string
    @uprn_list.map { |uprn| "UPRN=#{uprn}" }.join(' OR ')
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
      self.class.send(:define_method, key.en.plural) { atts.map(&key.to_sym) }
    end
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

  def x_y_coords
    raise UprnsDontMatchError if uprns != @uprn_list
    geometry.map(&:x).zip(geometry.map(&:y))
  end

end
