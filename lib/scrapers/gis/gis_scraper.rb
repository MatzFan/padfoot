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

class GisScraper

  Linguistics.use(:en) # for plural method

  DOMAIN = 'https://gps.digimap.gg/'

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
  end

end
