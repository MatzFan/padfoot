class NamesTransaction < Sequel::Model # Sequel only pluralizes last word..

  many_to_one :party_role, key: :role

  def before_save
    DB.transaction do
      PartyRole.find_or_create(name: self.role) if self.role
    end
    super
  end

end
