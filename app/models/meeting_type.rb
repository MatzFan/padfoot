class MeetingType < Sequel::Model

  unrestrict_primary_key
  one_to_many :meetings, key: :name

end
