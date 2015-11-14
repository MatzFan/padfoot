Sequel.migration do
  change do

    create_table :transaction_types do
      String :name, primary_key: true
    end

    create_table :transactions do
      primary_key :id
      Date :date
      Integer :book_num
      Integer :page_num
      Integer :doc_num
      String :summary_details
      foreign_key :type, :transaction_types, type: String
    end

    create_table :party_roles do
      String :name, primary_key: true
    end

    create_table :names do
      primary_key :id
      TrueClass :current
      String :surname
      String :forename
      String :maiden_name
    end

    create_table :parties do
      String :ext_text
      foreign_key :role, :party_roles, type: String
      foreign_key :transaction_id, :transactions
      foreign_key :name_id, :names
      primary_key [:transaction_id, :name_id]
      index [:transaction_id, :name_id]
    end

    create_table :trans_props do
      primary_key :id
      String :parish
      String :address
      foreign_key :transaction_id, :transactions
      foreign_key :property_uprn, :properties
    end

  end
end
