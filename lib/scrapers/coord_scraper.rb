require 'mechanize'

class JSONParser < Mechanize::File
  attr_reader :json

  def initialize(uri=nil, response=nil, body=nil, code=nil)
    super(uri, response, body, code)
    @json = JSON.parse(body)
  end
end

class Hash
  def geometry; self['geometry']; end
  def attributes; self['attributes']; end
  def x; self['x']; end
  def y; self['y']; end
  def uprns; self['UPRN']; end
end

class UprnsDontMatchError < StandardError; end

###############################################################################

class CoordScraper

  URL = 'https://gps.digimap.gg/arcgis/rest/services/StatesOfJersey/JerseyPlanning/MapServer/0/query'
  FIELDS = ['where', 'text', 'objectIds', 'time', 'inSR', 'relationParam',
    'outFields', 'maxAllowableOffset', 'geometryPrecision', 'outSR',
    'orderByFields', 'groupByFieldsForStatistics', 'gdbVersion', 'geometry',
    'outStatistics', 'geometryType', 'spatialRel', 'f']
  RADIOS = ['returnGeometry', 'returnGeometry' ,'returnIdsOnly',
    'returnIdsOnly', 'returnCountOnly','returnCountOnly', 'returnZ', 'returnZ',
    'returnM', 'returnM', 'returnDistinctValues', 'returnDistinctValues']

  attr_reader :form

  def initialize(*uprns)
    @uprns = uprns.flatten
    raise ArgumentError unless @uprns.dup.sort == @uprns
    @agent = Mechanize.new
    @agent.pluggable_parser['text/plain'] = JSONParser # not 'application/json'..??
    @form = form
    @json = json
    @out_uprns = out_uprns
    validate
  end

  def validate
    raise Error unless @form.fields.map(&:name) == FIELDS &&
    @form.radiobuttons.map(&:name) == RADIOS
  end

  def form
    @agent.get(URL).forms.first
  end

  def set_params
    @form.fields[0].value = query_string # SQL 'WHERE' clause
    @form.fields[6].value = 'UPRN' # output fields
    @form.fields[10].value = 'UPRN' # order by field
    @form.field_with(name: 'f').options[1].select # for JSON
  end

  def query_string
    @uprns.map { |uprn| "UPRN=#{uprn}" }.join(' OR ')
  end

  def json
    set_params
    @form.submit(@form.buttons[0]).json
  end

  def x_y_coords
    raise UprnsDontMatchError if out_uprns != @uprns
    x_coords.zip(y_coords)
  end

  def x_coords
    @json['features'].map(&:geometry).map(&:x)
  end

  def y_coords
    @json['features'].map(&:geometry).map &:y
  end

  def out_uprns
    @json['features'].map(&:attributes).map(&:uprns)
  end

  def data

  end

end
