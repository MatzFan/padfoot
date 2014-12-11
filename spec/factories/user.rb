FactoryGirl.define do
  # sequence(:email){ |n| "test.user#{n}@gmail.com" }

  factory :user do
    name 'Test User'
    email 'test.user@gmail.com'
    password 'password'
  end
end
