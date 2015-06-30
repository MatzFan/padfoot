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

    create_table :parties do
      primary_key :id
      String :surname
      String :maiden_name
      String :forename
      String :ext_text
      foreign_key :role, :party_roles, type: String
      foreign_key :transaction_id, :transactions
    end

    create_table :trans_props do
      primary_key :id
      Integer :uprn
      String :parish
      String :address
      foreign_key :transaction_id, :transactions
    end

  end
end
