class Application < Sequel::Model

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
DATES_TABLE_TITLES = ['ValidDate',
                      'AdvertisedDate',
                      'endpublicityDate',
                      'SitevisitDate',
                      'CommitteeDate',
                      'Decisiondate',
                      'Appealdate',
                      ]

  unrestrict_primary_key
  many_to_one :app_categories, key: :app_category
  many_to_one :app_officers, key: :app_officer
  many_to_one :app_statuses, key: :app_status
  many_to_one :parish_aliases, key: :app_parish
  many_to_one :agent_aliases, key: :app_agent

end
