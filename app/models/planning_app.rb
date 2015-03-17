class PlanningApp < Sequel::Model

  unrestrict_primary_key
  many_to_one :category, key: :app_category
  many_to_one :officer, key: :app_officer
  many_to_one :status, key: :app_status
  many_to_one :agent_alias, key: :app_agent
  many_to_one :parish_alias, key: :app_parish

  one_to_many :planning_app_constraints, key: :app_ref
  many_to_many :constraints, left_key: :app_ref, right_key: :name
  many_to_many :documents, left_key: :app_ref, right_key: :id

  def before_validation
    # populate derivative fields
    code_year_number = self.app_ref.split('/')
    self.app_code = code_year_number[0]
    self.app_year = code_year_number[1].to_i
    self.app_number = code_year_number[2].to_i
    self.order = self.app_year * 10000 + self.app_number
    self.app_full_address = build_address
    self.app_address_of_applicant = build_address_of_applicant
    self.mapped = self.latitude && self.longitude
    self.geom = set_geom(self.latitude, self.longitude) if mapped
    self.list_app_constraints = breakify(all_constraints)
    super
  end

  def before_save
    DB.transaction do # populate parent tables first if need be, so FK's linked
      Category.find_or_create(code: self.app_category) if self.app_category
      Officer.find_or_create(name: self.app_officer) if self.app_officer
      Status.find_or_create(name: self.app_status) if self.app_status
      ParishAlias.find_or_create(name: self.app_parish) if self.app_parish
      AgentAlias.find_or_create(name: self.app_agent) if self.app_agent
      self.parish = parish_alias.parish.name if parish_alias && parish_alias.parish
      self.list_app_meetings = (doc_links ? breakify(doc_links) : nil)
    end
    super
  end

  def after_save
    add_constraints
  end

  DETAILS_TABLE_TITLES = ['Reference',
                          'Category',
                          'Status',
                          'Officer',
                          'Applicant',
                          'Description',
                          'ApplicationAddress',
                          'RoadName',
                          'Parish',
                          'PostCode',
                          'Constraints',
                          'Agent',
                          ]

  DETAILS_FIELDS = [:app_ref,
                    :app_category,
                    :app_status,
                    :app_officer,
                    :app_applicant,
                    :app_description,
                    :app_address,
                    :app_road,
                    :app_parish,
                    :app_postcode,
                    :app_constraints,
                    :app_agent,
                   ]

  DATES_TABLE_TITLES = ['ValidDate',
                        'AdvertisedDate',
                        'endpublicityDate',
                        'SitevisitDate',
                        'CommitteeDate',
                        'Decisiondate',
                        'Appealdate',
                        ]

  DATES_FIELDS = [:valid_date,
                  :advertised_date,
                  :end_pub_date,
                  :site_visit_date,
                  :committee_date,
                  :decision_date,
                  :appeal_date,
                 ]

  def self.nearest_to(lat, long)
    x, y = coords(lat, long)
    PlanningApp.new(DB["SELECT * FROM planning_apps ORDER BY geom <-> '
      SRID=3109;POINT(#{x} #{y})'::geometry LIMIT 1"].first)
  end

  def self.within_circle(lat, long, radius) # radius in meters
    circle = "ST_Buffer(ST_Transform(ST_SetSRID(ST_MakePoint(#{long}, #{lat}), 4326), 3109), #{radius})::geometry"
    ds = DB["SELECT * from planning_apps WHERE ST_Contains(#{circle}, planning_apps.geom)"].all
    ds.map { |hash| PlanningApp.new(hash) }
  end

  def set_geom(lat, long)
    x, y = self.class.coords(lat, long)
    self.geom = DB["SELECT ST_SetSRID(ST_Point(#{x}, #{y}),3109)::geometry"]
  end

  def self.coords(lat, long)
    res = DB["SELECT ST_AsGeoJSON(ST_Transform(ST_SetSRID(ST_MakePoint(
      #{long}, #{lat}), 4326), 3109))"].first[:st_asgeojson]
    JSON.parse(res)['coordinates'].map { |c| c.round(6) }
  end

  def self.latest_app_num_for(year)
    self.where(app_year: year).order(:order).last[:app_number]
  end

  def build_address
    arr = [self.app_address, self.app_road, self.app_parish, self.app_postcode]
    breakify(arr)
  end

  def build_address_of_applicant
    breakify(splitify(self.app_applicant))
  end

  def splitify(string)
    string.split(',').map { |str| str.strip } if string
  end

  def breakify(string_arr)
    string_arr.join('<br/>') if string_arr
  end

  def all_constraints
    splitify(self.app_constraints).sort rescue nil
  end

  def add_constraints # populate constraints after, as app_ref FK in join table
    all_constraints.each do |c|
      Constraint.find_or_create(name: c) # before populating join table
      attributes = { name: c, app_ref: self.app_ref }
      num_records = DB[:constraints_planning_apps].where(attributes).count
      DB[:constraints_planning_apps].insert(attributes) if num_records == 0
    end if self.app_constraints
  end

  def doc_links
    doc_list.sort.reverse.map { |arr| linkify(arr[0], arr[1]) } if doc_list
  end

  def linkify(url, name)
    "<a href='#{url}' target='_blank'>#{name}</a>"
  end

  def doc_list
    self.documents.map do |doc|
      [DB[:documents_planning_apps].where(id: doc.id, app_ref: self.app_ref).select_map(:page_link).first, doc.name]
    end unless self.documents.empty?
  end

end
