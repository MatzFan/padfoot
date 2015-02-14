FactoryGirl.define do
  factory :document do
    name Faker::Lorem.word
    url Faker::Internet.url
    type Faker::Lorem.word
  end
end
