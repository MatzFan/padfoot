Sequel.migration do
  change do

    create_view :planning_apps_mapped, DB[:statuses].join(:planning_apps, :app_status => :name).join(:categories, :code => :app_category)

  end
end
