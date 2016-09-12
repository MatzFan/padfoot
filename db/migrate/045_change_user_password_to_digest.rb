Sequel.migration do
  up do
    alter_table :users do
      rename_column :password, :password_digest
      drop_column :password_confirmation
    end
  end

  down do
    alter_table :users do
      rename_column :password_digest, :password
      add_column :password_confirmation, String
    end
  end
end
