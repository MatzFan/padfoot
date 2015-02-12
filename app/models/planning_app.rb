class PlanningApp < Sequel::Model

  unrestrict_primary_key
  many_to_one :category, key: :app_category
  many_to_one :officer, key: :app_officer
  many_to_one :status, key: :app_status
  many_to_one :agent_alias, key: :app_agent
  many_to_one :parish_alias, key: :app_parish

  one_to_many :planning_app_constraints, key: :app_ref
  many_to_many :constraints, left_key: :app_ref, right_key: :name

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
    super
  end

  def before_save
    DB.transaction do # populate parent tables first if need be, so FK's linked
      Category.find_or_create(code: self.app_category) if self.app_category
      Officer.find_or_create(name: self.app_officer) if self.app_officer
      Status.find_or_create(name: self.app_status) if self.app_status
      ParishAlias.find_or_create(name: self.app_parish) if self.app_parish
      AgentAlias.find_or_create(name: self.app_agent) if self.app_agent
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

  def parish
    self.parish_alias.parish.name if self.parish_alias
  end

end
