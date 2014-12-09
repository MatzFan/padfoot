Sequel.migration do
  change do

    create_table :applications do
      String :app_ref, primary_key: true #PK
      foreign_key :app_agent, :agent_aliases, type: String
      foreign_key :app_category, :app_categories, type: String
      foreign_key :app_officer, :app_officers, type: String
      foreign_key :app_status, :app_statuses, type: String
      foreign_key :app_parish, :parish_aliases, type: String
      String :app_applicant
      String :app_address
      String :app_constraints
      String :app_description
      String :app_postcode, fixed: true, size: 7
      String :app_road
      Float :app_lat
      Float :app_long
    end

  end
end
