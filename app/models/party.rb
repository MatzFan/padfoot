class Party < Sequel::Model

  many_to_one :transaction, key: :party
  one_to_many :party_roles, key: :name

  def before_save
    DB.transaction do
      PartyRole.find_or_create(name: self.role) if self.role
    end
    super
  end

end
