Sequel.migration do
  change do

    create_table :people do
      primary_key :id
      String :surname
      String :forename
      String :maiden_name
    end

    create_table :entity_types do
      String :name, primary_key: true
    end

    create_table :juristictions do
      String :name, primary_key: true
    end

    create_table :entities do
      primary_key :id
      String :name
      String :ref
      foreign_key :type, :entity_types, type: String
      foreign_key :juristiction, :juristictions, type: String
    end

  end
end
