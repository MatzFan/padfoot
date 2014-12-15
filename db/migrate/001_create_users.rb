Sequel.migration do
  change do

    create_table :users do
      primary_key :id
      String :name, null: false
      String :email, null: false, unique: true
      String :password, null: false
      String :password_confirmation
      String :confirmation_code, null: false, default: 'none_sent_yet'
      FalseClass :confirmation, null: false, default: false
      String :authenticity_token
    end

  end
end
