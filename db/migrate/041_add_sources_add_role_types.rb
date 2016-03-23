Sequel.migration do
  up do
    create_table :sources do
      String :name, primary_key: true
    end

    create_table :role_types do
      String :name, primary_key: true
    end

    alter_table :transaction_types do
      add_column :interest, TrueClass # boolean
    end

    alter_table :transactions do
      add_foreign_key :source, :sources, type: String
    end

    alter_table :party_roles do
      add_foreign_key :role_type, :role_types, type: String
    end

    alter_table :people do
      drop_column :maiden_name
    end
  end

  down do
    alter_table :transaction_types do
      drop_column :interest
    end

    alter_table :transactions do
      drop_column :source
    end

    alter_table :party_roles do
      drop_column :role_type
    end

    alter_table :people do
      add_column :maiden_name, String
    end

    drop_table :sources

    drop_table :role_types
  end
end
