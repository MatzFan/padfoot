describe 'User Model' do

  let(:user) { build(:user) }

  it 'valid user can be created' do
    user.save
    expect(User.count).to eq 1
  end

  it 'must not have a blank name' do
    user.name = ''
    expect(user).not_to be_valid
  end

  it 'must not have a blank email' do
    user.email = ''
    expect(user).not_to be_valid
  end

  describe "passwords" do

    it 'must not have a blank email' do
      user.password = ''
      expect(user).not_to be_valid
    end

    pending('no blank password_confirmation')

  end

  describe "when name is already used" do
    pending('should not be saved')
  end

  describe "email address" do
    pending('valid')
    pending('not valid')
  end

end
