class Document < Sequel::Model

  many_to_one :document_types, key: :name
  many_to_one :meetings

  many_to_many :planning_apps, left_key: :id, right_key: :app_ref

  def before_save
    DocumentType.find_or_create(name: self.type) if self.type
    super
  end

  def self.unlinked_docs
    self.all.reject(&:has_linked_apps?)
  end

  def has_linked_apps?
    self.planning_apps != []
  end

end
