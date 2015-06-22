FactoryGirl.define do
  sequence(:name){ |n| "Faker::Lorem.word#{n}" }
  sequence(:url){ |n| "Faker::Internet.url#{n}" }
  sequence(:type){ |n| "Faker::Lorem.word#{n}" }

  factory :document do
    name
    url
    type
  end
end
