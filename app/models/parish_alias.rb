class ParishAlias < Sequel::Model

  unrestrict_primary_key
  one_to_many :planning_apps, key: :app_parish
  many_to_one :parish, key: :parish_num

end
