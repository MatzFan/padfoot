Sequel.migration do
  change do

    alter_table :properties do
      add_column :geom, 'geometry(POINT,3109)'
    end

  end
end
