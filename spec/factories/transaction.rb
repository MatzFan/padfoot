FactoryGirl.define do
  factory :transaction do
    date Date.today
    book_num 1234
    page_num 999
    doc_num 1
    summary_details Faker::Lorem.words
    type Faker::Lorem.word
  end
end
