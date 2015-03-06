class RoadName < Sequel::Model

  unrestrict_primary_key
  one_to_many :addresses
  one_to_many :properties

end
