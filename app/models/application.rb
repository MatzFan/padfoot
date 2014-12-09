class Application < Sequel::Model

  unrestrict_primary_key
  many_to_one :app_categories
  many_to_one :app_officers
  many_to_one :app_statuses
  many_to_one :parish_aliases
  many_to_one :agent_aliases

end
