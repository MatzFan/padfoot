FactoryGirl.define do
  factory :trans_prop do
    uprn 98123456
    parish 'St. Brelade'
    address Faker::Lorem.words.join(', ')
  end
end
