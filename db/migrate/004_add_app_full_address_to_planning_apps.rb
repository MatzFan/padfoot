Sequel.migration do
  change do
    add_column :planning_apps, :app_full_address, String
  end
end
