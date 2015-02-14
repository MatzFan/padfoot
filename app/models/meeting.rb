class Meeting < Sequel::Model

  many_to_one :meeting_types, key: :name
  one_to_many :documents

  def before_save
    MeetingType.find_or_create(name: self.type) if self.type
    super
  end

end
