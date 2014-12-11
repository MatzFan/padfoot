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

    it 'must be at least 8 characters' do
      user.password = '1234567'
      expect(user).not_to be_valid
    end

  end

  describe 'email address' do
    it 'should not be valid, if already in the DB' do
      user.save
      expect(user).not_to be_valid
    end

    it 'should not be invalid, if not in correct format' do
      user.email = 'load of rubbish'
      expect(user).not_to be_valid
    end
  end

end
