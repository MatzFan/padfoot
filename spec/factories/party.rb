FactoryGirl.define do
  factory :party do
    role Faker::Lorem.word
    surname Faker::Lorem.word
    maiden_name Faker::Lorem.word
    forename Faker::Lorem.word
    ext_text Faker::Lorem.words.join(', ')
  end
end
