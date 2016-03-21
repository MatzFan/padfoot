Sequel.migration do
  up do
    alter_table :names_transactions do
      drop_column :transaction_id
      drop_column :name_id # drops old pk & index
      add_foreign_key :transaction_id, :transactions
      add_foreign_key :name_id, :names
      add_primary_key [:transaction_id, :name_id, :role] # include role
      add_index [:transaction_id, :name_id, :role] # include role
    end
  end

  down do
    alter_table :names_transactions do
      drop_column :transaction_id
      drop_column :name_id
      drop_column :role
      add_foreign_key :transaction_id, :transactions
      add_foreign_key :name_id, :names
      add_foreign_key :role, :party_roles, type: String
      add_primary_key [:transaction_id, :name_id] # no role
      add_index [:transaction_id, :name_id] # no role
    end
  end
end
