describe '/properties' do
  before(:each) { build(:user).save }

  def mock_session
    { 'rack.session' => { current_user: 1 } }
  end

  context 'GET #index' do
    it 'renders :index view' do
      get '/properties/index', {}, mock_session
      expect(last_response).to be_ok
    end
  end
end
