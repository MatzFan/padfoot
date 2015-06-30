describe PartyRole do

  it 'can be created' do
    party_role = PartyRole.new(name: Faker::Lorem.word)
    expect(->{party_role.save}).not_to raise_error
  end

end
