FactoryGirl.define do

  factory :planning_app do
    valid_date DateTime.parse(Time.now.to_s).to_date
    app_category 'RW'
    sequence(:app_ref, 2013) { |n| "#{app_category}/#{n}/#{n - 2000}" }
    app_status 'APPEAL'
    app_officer 'Richard Greig'
    app_parish 'St. Brelade'
    app_constraints Faker::Lorem.words.join(', ')
  end
end
