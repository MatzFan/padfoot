require 'mechanize'

class JSONParser < Mechanize::File

  attr_reader :json

  def initialize(uri=nil, response=nil, body=nil, code=nil)
    super(uri, response, body, code)
    @json = JSON.parse(body)
  end

end

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

  def initialize(uprn)
    @uprn = uprn
    @agent = Mechanize.new
    @agent.pluggable_parser['text/plain'] = JSONParser # not 'application/json'..??
    @form = form
    validate
  end

  def validate
    raise error unless @form.fields.map(&:name) == FIELDS &&
    @form.radiobuttons.map(&:name) == RADIOS
  end

  def form
    @agent.get(URL).forms.first
  end

  def set_params
    @form.fields[0].value = CGI.escapeHTML("UPRN=#{@uprn}")
    @form.field_with(name: 'f').options[1].select # for JSON
  end

  def json
    set_params
    @form.submit(@form.buttons[0]).json
  end

  def x_y_coords
    json['features'][0]['geometry'].values.map(&:to_f)
  end

end