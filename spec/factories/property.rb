FactoryGirl.define do
  factory :property do
    type Faker::Lorem.word
    uprn 69003083
    prop_html 'Digimap (Jersey) Limited<br/>25 Pier Road<br/>St. Helier<br/>JE2 4XW'
    road Faker::Lorem.words(4).join(' ')
    parish_num 9
    p_code 'JE2 9XZ'
    x 42035.15699999966
    y 65219.985874999315
  end
end
