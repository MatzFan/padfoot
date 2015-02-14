class Document < Sequel::Model

  many_to_one :document_types, key: :name
  many_to_one :meetings

  def before_save
    DocumentType.find_or_create(name: self.type) if self.type
    super
  end

end
