# non individual legal person
class Entity < Sequel::Model
  one_to_many :names
  many_to_one :juristicion
  many_to_one :entity_type

  def before_save
    DB.transaction do
      EntityType.find_or_create(name: type) if type
      Juristiction.find_or_create(name: juristiction) if juristiction
    end
    super
  end
end
