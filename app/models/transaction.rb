class Transaction < Sequel::Model

  many_to_one :transaction_type, key: :type
  one_to_many :trans_props
  many_to_many :names

  def before_save
    DB.transaction do
      TransactionType.find_or_create(name: self.type) if self.type
    end
    super
  end

end
