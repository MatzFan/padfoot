describe Entity do

  let(:entity) { build(:entity) }

  it 'can be created' do
    entity.save
    expect(Entity.count).to eq 1
  end

end
