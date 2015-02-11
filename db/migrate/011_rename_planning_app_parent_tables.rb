Sequel.migration do
  change do

    rename_table(:app_categories, :categories)
    rename_table(:app_statuses, :statuses)
    rename_table(:app_officers, :officers)

  end
end
