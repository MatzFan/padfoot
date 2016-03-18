Sequel.migration do
  up do
    alter_table :trans_props do
      add_column :add_1, String
      add_column :add_2, String
      add_column :add_3, String
      drop_column :address
    end
  end

  down do
    alter_table :trans_props do
      drop_column :add_1
      drop_column :add_2
      drop_column :add_3
      add_column :address, String
    end
  end
end
