Sequel.migration do
  change do

    create_table :road_names do
      String :name, primary_key: true #PK
    end

    create_table :addresses do
      primary_key :id
      String :lines1to5
      foreign_key :road, :road_names, type: String
      foreign_key :parish_num, :parishes, type: Integer
      foreign_key :p_code, :postcodes, type: String
    end

  end
end
