class Document < Sequel::Model

  many_to_one :document_types, key: :name
  many_to_one :meetings

  many_to_many :planning_apps, left_key: :id, right_key: :app_ref

  def before_save
    DocumentType.find_or_create(name: self.type) if self.type
    super
  end

  def _add_planning_app(app, opts = {}) # overide method, so page_link can be added via opts hash
    rec = DB[:documents_planning_apps].where(app_ref: app.app_ref, id: self.id)
    DB[:documents_planning_apps].insert(opts.merge(app_ref: app.app_ref, id: self.id)) if rec.count == 0
  end

  def self.linked_docs
    self.all.select(&:has_linked_apps?)
  end

  def self.unlinked_docs
    self.all.reject(&:has_linked_apps?)
  end

  def has_linked_apps?
    self.planning_apps != []
  end

end
