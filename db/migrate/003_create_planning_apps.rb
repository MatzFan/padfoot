Sequel.migration do
  change do

    create_table :planning_apps do
      String :app_ref, primary_key: true #PK
      String :app_code
      Integer :app_year
      Integer :app_number
      foreign_key :app_agent, :agent_aliases, type: String
      foreign_key :app_category, :app_categories, type: String
      foreign_key :app_officer, :app_officers, type: String
      foreign_key :app_status, :app_statuses, type: String
      foreign_key :app_parish, :parish_aliases, type: String
      String :app_applicant
      String :app_address
      String :app_constraints
      String :app_description
      String :app_postcode
      String :app_road
      Float :latitude
      Float :longitude
      Date :valid_date
      Date :advertised_date
      Date :end_pub_date
      Date :site_visit_date
      Date :committee_date
      Date :decision_date
      Date :appeal_date
      Integer :order, unique: true
    end

  end
end
