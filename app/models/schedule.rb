class Schedule < Sequel::Model

  unrestrict_primary_key
  one_to_many :buses, key: :days

end
