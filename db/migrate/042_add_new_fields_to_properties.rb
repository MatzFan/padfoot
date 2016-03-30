Sequel.migration do
  up do
    create_table :islands do
      String :name, primary_key: true
    end

    alter_table :properties do
      add_column :logical_status, Integer
      add_column :updated, Time
      add_foreign_key :island_name, :islands, type: String
    end
  end

  down do
    alter_table :properties do
      drop_column :logical_status
      drop_column :updated
      drop_column :island_name
    end

    drop_table :islands
  end
end
