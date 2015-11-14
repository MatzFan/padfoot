class Party < Sequel::Model

  # many_to_one :transaction, key: :party
  many_to_one :party_role, key: :role

  def before_save
    DB.transaction do
      PartyRole.find_or_create(name: self.role) if self.role
      # Name.find_or_create(forename: self.forename, surname: self.surname)
      # Name.find_or_create(forename: self.forename, surname: self.maiden_name) if self.maiden_name
    end
    super
  end

end
