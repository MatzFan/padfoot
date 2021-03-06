describe 'PageController' do

  describe 'GET #contact' do
    it 'renders the :contact view' do
      get '/contact'
      expect(last_response).to be_ok
    end
  end

  describe 'GET #home' do
    it 'renders :home view' do
      get '/'
      expect(last_response).to be_ok
    end
  end

end
