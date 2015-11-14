class Name < Sequel::Model

  many_to_one :entity
  many_to_one :person
  many_to_many :transactions, left_key: :id, right_key: :id

end
