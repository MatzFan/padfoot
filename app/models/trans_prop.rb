class TransProp < Sequel::Model

  many_to_one :transaction, key: :property

end
