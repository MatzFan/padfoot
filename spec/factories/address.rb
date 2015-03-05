FactoryGirl.define do
  factory :address do
    lines1to5 Faker::Lorem.words(5).join('<br/>')
    road Faker::Lorem.words(4).join(' ')
    parish_num 9
    p_code 'JE2 9XZ'
  end
end
