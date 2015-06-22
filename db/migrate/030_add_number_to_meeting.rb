Sequel.migration do
  change do

    alter_table :meetings do
      add_column :number, Integer
    end

  end
end
