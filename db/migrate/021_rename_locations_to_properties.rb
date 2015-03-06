Sequel.migration do
  change do

    alter_table(:locations) do
      rename_column :loc_lat, :prop_lat
      rename_column :loc_long, :prop_long
      rename_column :loc_address, :prop_html
    end

    rename_table(:locations, :properties)

  end
end

