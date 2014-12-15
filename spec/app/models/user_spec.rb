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

  it 'must not have a blank confirmation_code' do
    user.confirmation_code = ''
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
      second_user = build(User)
      second_user.email = User.first.email
      expect(second_user).not_to be_valid
    end

    it 'should not be invalid, if not in correct format' do
      user.email = 'load of rubbish'
      expect(user).not_to be_valid
    end
  end

  describe 'confirmation code' do

    it 'should not authenticate user with incorrect confirmation code' do
      expect(user.authenticate('wrongcode')).to eq(false)
    end

    it 'should authenticate user with correct confirmation code' do
      user.save
      unconfirmed_user = User.find(email: user.email)
      code = unconfirmed_user.confirmation_code
      expect(user.authenticate(code)).to eq(true)
    end

    it 'confirmation should be set to true after a user is authenticated' do
      user.save
      unconfirmed_user = User.first
      code = unconfirmed_user.confirmation_code
      unconfirmed_user.authenticate(code)
      expect(unconfirmed_user.confirmation).to eq(true)
    end

  end
end
