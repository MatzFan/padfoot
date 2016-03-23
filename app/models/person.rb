# a natual person - represented by their birth name (maiden name)
class Person < Sequel::Model
  one_to_many :names
end
