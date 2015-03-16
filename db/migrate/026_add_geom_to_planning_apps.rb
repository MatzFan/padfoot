Sequel.migration do
  change do

    alter_table :planning_apps do
      add_column :geom, 'geometry(POINT,3109)'
    end

  end
end
