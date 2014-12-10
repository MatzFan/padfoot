class Application < Sequel::Model

  unrestrict_primary_key
  many_to_one :app_categories, key: :app_category
  many_to_one :app_officers, key: :app_officer
  many_to_one :app_statuses, key: :app_status
  many_to_one :parish_aliases, key: :app_parish
  many_to_one :agent_aliases, key: :app_agent

end
