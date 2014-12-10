class AgentAlias < Sequel::Model

  unrestrict_primary_key
  one_to_many :applications, key: :app_agent

end
