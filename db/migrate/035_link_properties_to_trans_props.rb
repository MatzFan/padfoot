Sequel.migration do
  change do

    alter_table :trans_props do
      add_foreign_key :property_uprn, :properties, type: Integer
    end

  end
end
