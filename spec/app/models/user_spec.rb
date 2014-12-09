describe 'User Model' do

  let(:user) { User.create(name: 'Bruce', email: 'bruce.steedman@gmail.com') }

  it 'can be created' do
    expect(user).not_to be_nil
  end

end
