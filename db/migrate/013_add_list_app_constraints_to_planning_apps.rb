Sequel.migration do
  change do
    add_column :planning_apps, :list_app_constraints, String
  end
end
