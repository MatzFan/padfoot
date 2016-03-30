describe Island do
  let(:island) { Island.new(name: 'Jersey') }

  context '#new' do
    it 'can be created' do
      island.save
      expect(Island.count).to eq(1)
    end
  end
end
