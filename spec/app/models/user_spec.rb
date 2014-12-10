describe 'User Model' do

  let(:user) { create(:user) }

  it 'can be created' do
    expect(user).not_to be_nil
  end

end
