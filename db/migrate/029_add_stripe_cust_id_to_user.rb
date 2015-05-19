Sequel.migration do
  change do

    alter_table :users do
      add_column :stripe_cust_id, String
    end

  end
end
