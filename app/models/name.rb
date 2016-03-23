# represents transactor persons (individuals & entities)
class Name < Sequel::Model
  P = Person

  many_to_one :entity
  many_to_one :person
  many_to_many :transactions

  def before_save
    forename ? do_person : do_entity
    super
  end

  def do_person
    if maiden_name
      self.person_id = P.find_or_create(forename: forename, surname: maiden_name).id
    else
      self.person_id = P.find_or_create(forename: forename, surname: surname).id
    end
  end

  def do_entity
    self.entity_id = Entity.find_or_create(name: surname).id
  end
end
