class Person < Sequel::Model

  one_to_many :names

  def after_save
    if self.maiden_name
      Name.find_or_create(forename: self.forename, surname: self.maiden_name)
    end
    super
  end

end
