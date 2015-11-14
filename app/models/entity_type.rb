class EntityType < Sequel::Model

  unrestrict_primary_key
  one_to_many :entities

end
