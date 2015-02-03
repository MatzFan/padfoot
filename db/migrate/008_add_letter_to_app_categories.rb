Sequel.migration do
  change do
    add_column :app_categories, :letter, String
  end
end
