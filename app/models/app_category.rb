class AppCategory < Sequel::Model

  unrestrict_primary_key
  one_to_many :planning_apps, key: :app_category

end
