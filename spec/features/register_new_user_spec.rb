describe 'Registering a new user', type: :feature do
  it "redirects to the application root" do

    user = build(:user)

    visit '/register'
    fill_in 'user_name', with: user.name
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password
    click_button 'Register'
    expect(current_path).to eq '/'
  end
end
