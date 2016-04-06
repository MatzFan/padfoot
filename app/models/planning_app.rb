# represents planning applications
class PlanningApp < Sequel::Model
  extend Mappable
  extend PushpinPlottable

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
    code_year_number = app_ref.split('/')
    self.app_code = code_year_number[0]
    self.app_year = code_year_number[1].to_i
    self.app_number = code_year_number[2].to_i
    self.order = app_year * 10_000 + app_number
    self.app_full_address = build_address
    self.app_address_of_applicant = build_address_of_applicant
    self.mapped = latitude && longitude
    self.geom = set_geom(latitude, longitude) if mapped
    self.list_app_constraints = breakify(all_constraints)
    super
  end

  def before_save
    DB.transaction do
      Category.find_or_create(code: app_category) if app_category
      Officer.find_or_create(name: app_officer) if app_officer
      Status.find_or_create(name: app_status) if app_status
      ParishAlias.find_or_create(name: app_parish) if app_parish
      AgentAlias.find_or_create(name: app_agent) if app_agent
      self.parish = parish_alias.parish.name if
        parish_alias && parish_alias.parish
      self.list_app_meetings = (doc_links ? breakify(doc_links) : nil)
    end
    super
  end

  def after_save
    add_constraints
  end

  TABLE_COLS = [:order, :valid_date, :app_ref, :app_code, :app_status,
                :app_full_address, :app_description, :app_address_of_applicant,
                :app_agent, :app_officer, :parish, :list_app_constraints,
                :list_app_meetings].freeze

  TABLE_TITLES = %w(Order Date Ref Code Status Address Description Applicant
                    Agent Officer Parish Constraints Meetings).freeze

  PUSHIN_COLUMNS = [:app_ref, :app_status, :app_category,
                    :app_full_address, :latitude, :longitude].freeze

  DETAILS_TABLE_TITLES = %w(Reference Category Status Officer Applicant
                            Description ApplicationAddress RoadName Parish
                            PostCode Constraints Agent).freeze

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
                    :app_agent].freeze

  DATES_TABLE_TITLES = %w(ValidDate AdvertisedDate endpublicityDate
                          SitevisitDate CommitteeDate Decisiondate
                          Appealdate).freeze

  DATES_FIELDS = [:valid_date,
                  :advertised_date,
                  :end_pub_date,
                  :site_visit_date,
                  :committee_date,
                  :decision_date,
                  :appeal_date].freeze

  def self.pushpin_colours_hash
    Status.select_hash(:name, :colour)
  end

  def self.pushpin_letters_hash
    Category.select_hash(:code, :letter)
  end

  def set_geom(lat, long)
    x, y = self.class.coords(lat, long)
    self.geom = DB["SELECT ST_SetSRID(ST_Point(#{x}, #{y}),3109)::geometry"]
  end

  def self.latest_app_num_for(year)
    where(app_year: year).order(:order).last[:app_number]
  end

  def build_address
    arr = [app_address, app_road, app_parish, app_postcode]
    breakify(arr)
  end

  def build_address_of_applicant
    breakify(splitify(app_applicant))
  end

  def splitify(string)
    string.split(',').map(&:strip) if string
  end

  def breakify(string_arr)
    string_arr.join('<br/>') if string_arr
  end

  def all_constraints
    splitify(app_constraints).sort rescue nil
  end

  def add_constraints # populate constraints after, as app_ref FK in join table
    all_constraints.each do |c|
      Constraint.find_or_create(name: c) # before populating join table
      attributes = { name: c, app_ref: app_ref }
      num_records = DB[:constraints_planning_apps].where(attributes).count
      DB[:constraints_planning_apps].insert(attributes) if num_records == 0
    end if app_constraints
  end

  def doc_links
    doc_list.sort.reverse.map { |arr| linkify(arr[0], arr[1]) } if doc_list
  end

  def linkify(url, name)
    "<a href='#{url}' target='_blank'>#{name}</a>"
  end

  def doc_list
    documents.map do |doc|
      [DB[:documents_planning_apps].where(
        id: doc.id, app_ref: app_ref).select_map(
          :page_link).first, doc.name]
    end unless documents.empty?
  end
end
