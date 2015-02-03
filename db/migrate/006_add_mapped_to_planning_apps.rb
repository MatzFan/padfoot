Sequel.migration do
  change do
    add_column :planning_apps, :mapped, TrueClass
  end
end
