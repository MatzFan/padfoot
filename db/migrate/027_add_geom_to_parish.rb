Sequel.migration do
  change do

    alter_table :parishes do
      add_column :geom, 'geometry(POLYGON,3109)'
    end

  end
end
