class PartyRole < Sequel::Model

  unrestrict_primary_key
  many_to_one :name_transaction, key: [:name_id, :transaction_id]

end
