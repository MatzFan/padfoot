FactoryGirl.define do
  factory :meeting do
    type 'MM'
    date DateTime.parse(Time.now.to_s).to_date
  end
end
