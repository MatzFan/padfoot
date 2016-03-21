describe Transaction do
  T = Transaction
  let(:transaction) { build(:transaction) }

  context '#create' do
    it 'can be created' do
      transaction.save
      expect(T.count).to eq(1)
    end
  end

  context '#transaction_type' do
    it 'will have an associated TransactionType' do
      transaction.save
      expect(Transaction.first.transaction_type.name).to eq(T.first.type)
    end

    it 'will have an associated TransactionType' do
      transaction.save
      expect(Transaction.first.transaction_type.name).to eq(T.first.type)
    end
  end

  context '#add_name' do
    it 'adds a new Names record' do
      transaction.save
      T.first.add_name(surname: 'Bloggs', forename: 'Joe')
      expect(Name.count).to eq 1
    end
  end
end
