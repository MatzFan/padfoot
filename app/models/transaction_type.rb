class TransactionType < Sequel::Model

  unrestrict_primary_key
  one_to_many :transactions, key: :type

end
