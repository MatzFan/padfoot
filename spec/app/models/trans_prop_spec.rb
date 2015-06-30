describe TransProp do

  let(:prop) { build(:trans_prop) }
  let(:transaction) { create(:transaction) }

  context '#new' do
    it 'can be created from a transaction' do
      transaction
      Transaction.first.add_trans_prop(prop)
      expect(TransProp.count).to eq(1)
    end

    it 'meeting_id will be nil if the parent meeting does not exist' do
      prop.save
      expect(prop.transaction_id).to be_nil
    end
  end

end
