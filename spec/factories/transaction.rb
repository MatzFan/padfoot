FactoryGirl.define do
  factory :transaction do
    nameSeq 564930
    docSeq 2034095
    date Date.today
    book_num 1234
    page_num 999
    page_suffix 'A'
    doc_num 1
    summary_details Faker::Lorem.words
    type Faker::Lorem.word
  end
end
