Sequel.migration do
  change do

    create_table :property_types do
      String :name, primary_key: true
    end

    alter_table :properties do
      add_foreign_key :type, :property_types, type: String, key: :name
      add_column :object_id, Integer
      add_column :guid, Integer
      add_column :add1, String
      add_column :add2, String
      add_column :add3, String
      add_column :add4, String
      add_column :usrn, Integer
      add_column :address1, String
      add_column :vingtaine, String
    end
  end

end
