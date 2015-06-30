describe TransProp do

  let(:party) { build(:party) }
  let(:transaction) { create(:transaction) }

  context '#new' do
    it 'can be created from a transaction' do
      transaction
      Transaction.first.add_party(party)
      expect(Party.count).to eq(1)
    end

    it 'meeting_id will be nil if the parent meeting does not exist' do
      party.save
      expect(party.transaction_id).to be_nil
    end
  end

end
