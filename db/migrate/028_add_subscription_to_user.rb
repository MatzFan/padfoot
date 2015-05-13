Sequel.migration do
  change do

    alter_table :users do
      add_column :subscription, FalseClass, null: false, default: false
    end

  end
end
