class Name < Sequel::Model

  NAMES = [:surname, :forename, :maiden_name]

  many_to_one :entity
  many_to_one :person
  many_to_many :transactions

  def before_save
    DB.transaction do
      names_hash = NAMES.zip(NAMES.map { |sym| self.send sym })
      if self.forename
        if self.maiden_name # add it to maiden Person record, if found
          maiden = Person.find(forename: self.forename, surname: self.maiden_name)
          maiden.update(maiden_name: self.maiden_name) if maiden
        else
          self.person_id = Person.find_or_create(names_hash).id
        end
      else
        self.entity_id = Entity.find_or_create(name: self.surname).id
      end
    end
    super
  end

end
