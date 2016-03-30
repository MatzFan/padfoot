# represents transactor persons (individuals & entities)
class Name < Sequel::Model
  many_to_one :entity
  many_to_one :person
  many_to_many :transactions

  def before_save
    forename ? do_person : do_entity
    super
  end

  def do_person
    self.person_id = maiden_name ? p_id(maiden_name) : p_id(surname)
  end

  def p_id(name)
    Person.find_or_create(forename: forename, surname: name).id
  end

  def do_entity
    self.entity_id = Entity.find_or_create(name: surname).id
  end
end
