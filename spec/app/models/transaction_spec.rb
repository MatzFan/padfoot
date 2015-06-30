describe Transaction do

  let(:transaction) { create(:transaction) }

  it 'can be created' do
    transaction
    expect(Transaction.count).to eq(1)
  end

  it 'will have an associated TransactionType' do
    transaction
    expect(Transaction.first.transaction_type.name).to eq(Transaction.first.type)
  end

end
