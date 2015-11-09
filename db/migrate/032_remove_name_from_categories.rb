Sequel.migration do
  up do
    alter_table(:categories) do
      drop_column :name
    end
  end

  down do
    alter_table :categories do
      add_column :name, String
    end
  end
end
