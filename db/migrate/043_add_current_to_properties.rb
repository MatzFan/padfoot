Sequel.migration do
  change do
    alter_table :properties do
      add_column :current, TrueClass, default: true
    end
  end
end
