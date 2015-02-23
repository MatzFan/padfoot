Sequel.migration do
  change do

    create_table :postcodes do
      String :code, primary_key: true #PK
    end

  end
end
