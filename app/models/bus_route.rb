class BusRoute < Sequel::Model

  unrestrict_primary_key
  one_to_many :buses, key: :number

end
