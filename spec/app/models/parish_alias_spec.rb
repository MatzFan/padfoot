describe 'ParishAlias Model' do

  let(:parish_alias) { ParishAlias.create(name: 'St Helier') }

  it 'can be created' do
    expect(parish_alias).not_to be_nil
  end

end
