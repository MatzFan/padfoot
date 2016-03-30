FactoryGirl.define do
  factory :property do
    type Faker::Lorem.word
    uprn 69_003_083
    island_name 'Jersey'
    parish_num 9
    p_code 'JE2 9XZ'
    x 42_035.157
    y 65_219.985875
    updated Time.now
  end
end
