describe '/users' do
  context 'GET confirm' do
    let(:user) { create(:user) }
    let(:id) { user.id }
    let(:code) { user.confirmation_code }

    it "render the 'users/confirm' page if user has confirmation code" do
      get "/confirm/#{id}/#{code}"
      expect(last_request.path).to eq("/confirm/#{id}/#{code}")
    end

    it 'redirect the :confirm if user id is wrong' do
      get "/confirm/test/#{user.confirmation_code}"
      expect(last_response).to be_redirect
    end

    it 'redirect to :confirm if confirmation_code is wrong' do
      get "/confirm/#{user.id}/test"
      expect(last_response).to be_redirect
    end
  end

  describe 'GET edit' do
    let(:user) { build(:user) }

    it 'redirects if wrong id' do
      get '/users/-1/edit'
      expect(last_response).to be_redirect
    end

    it 'render the view for editing a user' do
      id = user.id
      allow(User).to receive(:[]) { user }
      get "/users/#{id}/edit", {}, 'rack.session' => { current_user: id }
      expect(last_response).to be_ok
    end
  end

  context 'PUT update' do
    let(:user) { build(:user) }

    it 'successful updates should be saved' do
      new_attributes = { name: 'new',
                         email: 'a.n@other.je',
                         password: 'new_password' }
      id = user.id
      allow(User).to receive(:[]) { user }
      put "users/#{id}",
          { user: new_attributes },
          'rack.session' => { current_user: id }
      expect(User[id].name).to eq('new')
    end

    it 'successful updates should redirect' do
      id = user.id
      allow(User).to receive(:[]) { user }
      put "users/#{id}",
          { user: { name: 'new' } },
          'rack.session' => { current_user: id }
      expect(last_response).to be_redirect
    end

    it 'stays on the page if the user has made input errors' do
      id = user.id
      allow(User).to receive(:[]) { user } # try empty name in request
      put "users/#{id}",
          { user: { name: '' } },
          'rack.session' => { current_user: id }
      expect(last_response).to be_ok
    end
  end
end
