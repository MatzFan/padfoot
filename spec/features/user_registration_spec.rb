require_relative 'features_helper'

describe 'Registering a new user', type: :feature do
  let(:user) { build(:user, email: 'test@example.com') }

  before do
    clear_emails
    visit '/register'
    fill_in 'user_name', with: user.name
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Register'
    open_email('test@example.com')
  end

  it 'redirects to the application root' do
    expect(current_path).to eq '/'
  end

  it 'sends a confirmation email' do
    expect(current_email).to have_content 'To confirm your registration'
  end

  it "sends an email with a link which confirms the user's registration" do
    current_email.click_link ''
    expect(page).to have_content 'your registration has been confirmed'
  end

  it 'sends an email with a link allows the user to subscribe' do
    id = User.first.id
    current_email.click_link ''
    expect(page).to have_link('subscribe', href: "/users/#{id}/subscribe")
  end
end
