# represents parties to a PRIDE transaction
class NamesTransaction < Sequel::Model # Sequel pluralizes last word..
  unrestrict_primary_key
  many_to_one :party_role, key: :role

  def before_save
    DB.transaction do
      PartyRole.find_or_create(name: role) if role
    end
    super
  end
end
