describe 'AppOfficer Model' do

  let(:app_officer) { AppOfficer.create(name: 'Joe Bloggs') }

  it 'can be created' do
    expect(app_officer).not_to be_nil
  end

end
