class Constraint < Sequel::Model

  unrestrict_primary_key
  one_to_many :planning_app_constraints, key: :name

end
