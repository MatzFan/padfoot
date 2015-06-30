describe TransactionType do

  it 'can be created' do
    trans_type = TransactionType.new(name: Faker::Lorem.word)
    expect(->{trans_type.save}).not_to raise_error
  end

end
