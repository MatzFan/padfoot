describe Postcode do

  let(:postcode) { build(:postcode) }

  context '#new' do
    it 'can be created' do
      postcode.save
      expect(Postcode.count).to eq(1)
    end
  end

end
