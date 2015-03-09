class PropertyType < Sequel::Model

  unrestrict_primary_key
  one_to_many :properties, key: :name

end
