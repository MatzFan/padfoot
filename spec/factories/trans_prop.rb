FactoryGirl.define do
  factory :trans_prop do
    property_uprn 98123456
    parish 'St. Brelade'
    address Faker::Lorem.words.join(', ')
  end
end
