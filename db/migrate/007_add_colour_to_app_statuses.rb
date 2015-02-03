Sequel.migration do
  change do
    add_column :app_statuses, :colour, String
  end
end
