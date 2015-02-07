class ParishAlias < Sequel::Model

  unrestrict_primary_key
  one_to_many :planning_apps, key: :app_parish
  many_to_one :parishes, key: :parish_num

end
