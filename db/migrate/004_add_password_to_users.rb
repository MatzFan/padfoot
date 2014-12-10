Sequel.migration do
  change do

    alter_table :users do
      add_column :password, String
    end

  end
end
