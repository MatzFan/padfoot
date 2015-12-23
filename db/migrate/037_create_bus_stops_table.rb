Sequel.migration do
  change do

    create_table :bus_stops do
      String :code, primary_key: true #PK
      String :name
      Float :latitude
      Float :longitude
    end

    alter_table :bus_stops do
      add_column :geom, 'geometry(POINT,3109)'
    end

  end
end
