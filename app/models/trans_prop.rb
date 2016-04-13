# represents a property in a transaction
class TransProp < Sequel::Model # use many_to_one side of 1-1 assoc.
  many_to_one :property, key: :property_uprn
  many_to_one :transaction

  def before_save
    DB.transaction do # populate property table first if need be, so FK's linked
      Property.find_or_create(uprn: property_uprn) if property_uprn
    end
    super
  end
end
