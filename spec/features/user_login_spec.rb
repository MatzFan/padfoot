describe 'Logging in', type: :feature do
  context 'a confirmed user' do
    context 'who is subscribed' do
      before(:each) do
        confirmed_user = create(:user, confirmation: true, subscription: true, email: 'test@example.com')
        visit '/login'
        fill_in 'email', with: confirmed_user.email
        fill_in 'password', with: confirmed_user.password
        click_button 'Sign in'
      end

      it 'redirects to applications/index' do
        expect(current_path).to eq '/applications/index'
      end
    end

    context 'who is not subscribed' do
      before(:each) do
        confirmed_user = create(:user, confirmation: true, email: 'test@example.com')
        visit '/login'
        fill_in 'email', with: confirmed_user.email
        fill_in 'password', with: confirmed_user.password
        click_button 'Sign in'
      end

      it 'redirects to the subscription page for that user' do
        id = User.first.id
        expect(current_path).to eq "/subscribe"
      end
    end
  end

  context 'a non-confirmed user' do
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
