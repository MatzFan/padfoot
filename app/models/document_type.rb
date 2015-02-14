class DocumentType < Sequel::Model

  unrestrict_primary_key
  one_to_many :documents, key: :name

end
