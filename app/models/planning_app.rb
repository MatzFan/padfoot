class PlanningApp < Sequel::Model

  unrestrict_primary_key
  many_to_one :app_categories, key: :app_category
  many_to_one :app_officers, key: :app_officer
  many_to_one :app_statuses, key: :app_status
  many_to_one :parish_aliases, key: :app_parish
  many_to_one :agent_aliases, key: :app_agent

  def before_create
    # populate derivative fields
    code_year_number = self.app_ref.split('/')
    self.app_full_address = build_address
    self.app_address_of_applicant = build_address_of_applicant
    self.app_code = code_year_number[0]
    self.app_year = code_year_number[1].to_i
    self.app_number = code_year_number[2].to_i
    self.order = self.app_year * 10000 + self.app_number
    # populate parent tables first if need be
    AppCategory.find_or_create(code: self.app_category) if self.app_category
    AppOfficer.find_or_create(name: self.app_officer) if self.app_officer
    AppStatus.find_or_create(name: self.app_status) if self.app_status
    ParishAlias.find_or_create(name: self.app_parish) if self.app_parish
    AgentAlias.find_or_create(name: self.app_agent) if self.app_agent
    super
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
    [self.app_address, self.app_road, self.app_parish, self.app_postcode].join('<br/>')
  end

  def build_address_of_applicant
    self.app_applicant.split(',').map { |s| s.strip }.join('<br/>') if app_applicant
  end

end
