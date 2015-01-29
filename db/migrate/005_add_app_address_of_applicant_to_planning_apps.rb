Sequel.migration do
  change do
    add_column :planning_apps, :app_address_of_applicant, String
  end
end
