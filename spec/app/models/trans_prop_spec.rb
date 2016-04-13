describe TransProp do
  uprn = 98123456
  let(:property) { build(:property, uprn: uprn) }
  let(:trans_prop) { build(:trans_prop, property_uprn: 98123456) }
  let(:transaction) { build(:transaction) }

  context 'belongs to Transaction association' do
    it 'means it can be created from a transaction' do
      transaction.save
      Transaction.first.add_trans_prop(trans_prop)
      expect(TransProp.count).to eq(1)
    end
  end

  context '#transaction' do
    it 'returns nil if there is no related Transaction' do
      trans_prop.save
      expect(trans_prop.transaction).to be_nil
    end

    it 'returns the related Transaction if there is one' do
      transaction.save
      Transaction.first.add_trans_prop(trans_prop)
      expect(TransProp.first.transaction).to eq Transaction.first
    end
  end

  context '#property' do
    it 'returns the related Property' do
      trans_prop.save
      expect(TransProp.first.property).to eq Property.first
    end
  end
end
