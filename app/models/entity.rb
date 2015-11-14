class Entity < Sequel::Model

  one_to_many :names
  many_to_one :juristicion
  many_to_one :entity_type

  def before_save
    DB.transaction do
      EntityType.find_or_create(name: self.type) if self.type
      Juristiction.find_or_create(name: self.juristiction) if self.juristiction
    end
    super
  end

end
