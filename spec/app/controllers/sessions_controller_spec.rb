RSpec.describe '/sessions' do

  describe 'GET :new' do
    it 'loads the login page' do
      get '/login'
      expect(last_response).to be_ok
    end
  end

  describe 'POST :create' do
    let(:user) { build(:user)}
    let(:params) { attributes_for(:user) } # FactoryGirl method

    it 'stay on page if user is not found' do
      allow(User).to receive(:find) { false }
      post '/create', user.values
      expect(last_response).to be_ok
    end

    it 'stay on login page if user is not confirmed' do
      user.confirmation = false
      allow(User).to receive(:find) { user }
      post '/create', user.values
      expect(last_response).to be_ok
    end

    it 'stay on login page if user has wrong email' do
      user.email = 'fake.email@gmail.com'
      allow(User).to receive(:find) { user }
      post '/create', user.values
      expect(last_response).to be_ok
    end

    it 'stay on login page if user has wrong password' do
      user.password = 'test'
      allow(User).to receive(:find) { user }
      post '/create', user.values
      expect(last_response).to be_ok
    end

    it 'redirect if user is correct' do
      user.confirmation = true
      allow(User).to receive(:find) { user }
      post '/create', user.values
      expect(last_response).to be_redirect
    end
  end

  private
  def post_create(params)
    post 'sessions/create', params
  end

  describe 'GET :logout' do
    it "empty the current session"
    it "redirect to homepage if user is logging out"
  end

end
