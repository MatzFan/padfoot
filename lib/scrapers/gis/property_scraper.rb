class PropertyScraper < GisScraper

  URL = 'arcgis/rest/services/StatesOfJersey/JerseyPlanning/MapServer/0/query'

  KEYS = ['OBJECTID', 'guid_', 'Add1', 'Add2', 'Add3', 'Add4', 'Parish',
          'Postcode', 'UPRN', 'USRN', 'Property_Type', 'Address1', 'Vingtaine']

  COLUMNS = [:object_id, :guid, :add1, :add2, :add3, :add4, :parish_num,
          :p_code, :uprn, :usrn, :type, :address1, :vingtaine]

  def initialize(lower_id = 0, upper_id = 0)
    super
    @keys = keys
    @form = form
    validate
    @json = json
    setup_hash_key_methods
    setup_accessor_methods
    @features = features
    @atts = atts
  end

  def keys
    KEYS.zip(COLUMNS).map { |arr| Hash[*arr] }.inject({}) { |m, e| m.merge(e) }
  end

  def form
    @agent.get(DOMAIN + URL).forms.first
  end

  def num_records
    form = Mechanize.new.get(DOMAIN + URL).forms.first
    form.fields[0].value = "OBJECTID > 0"
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
      Hash[@keys[key] => (e ? process(key, e) : nil)]
    end
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
