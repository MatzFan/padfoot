describe EntityType do

  let(:type) { EntityType.create(name: 'Company') }

  it 'can be created' do
    expect(type.class).to eq EntityType
  end

end
