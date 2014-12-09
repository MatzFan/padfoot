class AppCategory < Sequel::Model

  unrestrict_primary_key
  one_to_many :applications

end
