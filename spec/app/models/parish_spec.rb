describe 'Parish Model' do

  let(:parish) { Parish.create(number: 1, name: 'Grouville') }

  it 'can be created' do
    expect(parish).not_to be_nil
  end

end
