Sequel.migration do
  change do
    add_column :planning_apps, :list_app_meetings, String
  end
end
