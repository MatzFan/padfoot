Sequel.migration do
  change do
    add_column :planning_apps, :parish, String
  end
end
