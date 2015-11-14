describe Juristiction do

  let(:juristiction) { Juristiction.create(name: 'Jersey') }

  it 'can be created' do
    expect(juristiction.class).to eq Juristiction
  end

end
