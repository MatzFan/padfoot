describe 'AppStatus Model' do

  let(:app_status) { AppStatus.create(name: 'Pending') }

  it 'can be created' do
    expect(app_status).not_to be_nil
  end

end
