describe 'User Model' do

  let(:user) { FactoryGirl.build(:user) }

  it 'can be created' do
    expect(user).not_to be_nil
  end

end
