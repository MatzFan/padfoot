Sequel.migration do

  up do
    alter_table :trans_props do
      drop_column :uprn
    end
  end

  down do
    alter_table :trans_props do
      add_column :uprn, Integer
    end
  end

end
