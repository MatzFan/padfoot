Sequel.migration do
  change do

    alter_table :parishes do
      add_column :geom, 'geometry(MULTIPOLYGON,3109)'
    end

  end
end
