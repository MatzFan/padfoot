Sequel.migration do

  change do
    alter_table :properties do
      add_foreign_key :road, :road_names, type: String
      add_foreign_key :parish_num, :parishes, type: Integer
      add_foreign_key :p_code, :postcodes, type: String
    end
  end

end
