Sequel.migration do
  change do

    create_table :locations do
      Integer :uprn, primary_key: true #PK
      String :loc_address
      Float :x
      Float :y
      Float :loc_lat
      Float :loc_long
    end

  end
end
