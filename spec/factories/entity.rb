FactoryGirl.define do
  factory :entity do
    juristiction Faker::Lorem.word
    name Faker::Lorem.word
    type 'Company'
    ref '1234'
  end
end
