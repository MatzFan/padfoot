class TransProp < Sequel::Model

  many_to_one :property, key: :property_uprn
  many_to_one :transaction

  def before_save
    DB.transaction do # populate property table first if need be, so FK's linked
      Property.find_or_create(uprn: self.property_uprn) if self.property_uprn
    end
    super
  end

end
