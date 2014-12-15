FactoryGirl.define do
  sequence(:id){ |n| n }
  sequence(:email){ |n| "test.user#{n}@gmail.com" }

  factory :user do
    id
    name 'Test User'
    email
    password 'password'
    password_confirmation 'password'
    confirmation_code 'none_sent_yet'
  end
end
