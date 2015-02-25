Sequel.migration do
  change do
    alter_table(:planning_apps) do
      drop_constraint(:planning_apps_order_key, type: :unique)
    end
  end
end
