FactoryGirl.define do

  factory :planning_app do
    # app_ref 'RW/2014/0548'
    app_category 'RW'
    sequence(:app_ref, 2013) { |n| "#{app_category}/#{n}/#{n - 2000}" }
    app_status 'APPEAL'
    app_officer 'Richard Greig'
    app_parish 'St. Brelade'
  end
end
