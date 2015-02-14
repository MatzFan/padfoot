Sequel.migration do
  change do

    create_table :meeting_types do
      String :name, primary_key: true #PK
    end

    create_table :meetings do
      primary_key :id
      Date :date
      foreign_key :type, :meeting_types, type: String
    end

    create_table :document_types do
      String :name, primary_key: true #PK
    end

    create_table :documents do
      primary_key :id
      String :url
      String :name
      foreign_key :type, :document_types, type: String
      foreign_key :meeting_id, :meetings
    end

  end
end
