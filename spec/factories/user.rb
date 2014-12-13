FactoryGirl.define do
  sequence(:email){ |n| "test.user#{n}@gmail.com" }

  factory :user do
    name 'Test User'
    email
    password 'password'
    password_confirmation 'password'
    confirmation_code 'somecode'
  end
end
