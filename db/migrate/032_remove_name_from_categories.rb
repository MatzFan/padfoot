Sequel.migration do
  change do

    alter_table(:categories) do
      drop_column :name
    end

  end
end
