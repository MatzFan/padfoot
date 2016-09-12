require_relative 'features_helper'

describe 'Logging in', type: :feature do
  let(:pwd) { 'password' }
  let(:user) { create(:user, password: pwd, email: 'test@example.com') }

  context 'a non-confirmed user' do
    before(:each) do
      visit '/login'
      fill_in 'email', with: user.email
      fill_in 'password', with: pwd
      click_button 'Sign in'
    end

    it 'redirects to /create' do
      expect(current_path).to eq '/create'
    end

    it 'warns the users that login or password are wrong' do
      expect(page).to have_content('Your Email and/or Password is wrong')
    end
  end

  context 'a confirmed user' do
    before(:each) do
      user.confirmation = true
      user.save
    end
    context 'who is not subscribed' do
      before(:each) do
        visit '/login'
        fill_in 'email', with: user.email
        fill_in 'password', with: pwd
        click_button 'Sign in'
      end

      it 'redirects to the subscription page for that user' do
        expect(current_path).to eq "/users/#{User.first.id}/subscribe"
      end
    end

    context 'who is subscribed' do
      before(:each) do
        user.subscription = true
        user.save
        visit '/login'
        fill_in 'email', with: user.email
        fill_in 'password', with: pwd
        click_button 'Sign in'
      end

      it 'redirects to applications/index' do
        expect(current_path).to eq '/applications/index'
      end
    end
  end
end
