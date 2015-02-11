describe 'Officer Model' do

  let(:officer) { Officer.create(name: 'Joe Bloggs') }

  it 'can be created' do
    expect(officer).not_to be_nil
  end

end
