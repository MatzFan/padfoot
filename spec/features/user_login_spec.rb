describe 'Login', type: :feature do
  context 'for a confirmed user' do
    before(:each) do
      confirmed_user = create(:user, confirmation: true, email: 'test@example.com')
      visit '/login'
      fill_in 'email', with: confirmed_user.email
      fill_in 'password', with: confirmed_user.password
      click_button 'Sign in'
    end

    it 'redirects to applications/index' do
      expect(current_path).to eq '/applications/index'
    end
  end

  context 'for a non-confirmed user' do
    before(:each) do
      non_confirmed_user = create(:user, email: 'test@example.com')
      visit '/login'
      fill_in 'email', with: non_confirmed_user.email
      fill_in 'password', with: non_confirmed_user.password
      click_button 'Sign in'
    end

    it 'redirects to /create' do
      expect(current_path).to eq '/create'
    end

    it 'warns the users that login or password are wrong' do
      expect(page).to have_content('Your Email and/or Password is wrong')
    end
  end

end
