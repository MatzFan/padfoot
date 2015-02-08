class Constraint < Sequel::Model

  unrestrict_primary_key
  one_to_many :planning_app_constraints, key: :name

  many_to_many :planning_apps, left_key: :name, right_key: :app_ref

end
