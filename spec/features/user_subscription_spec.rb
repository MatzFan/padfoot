describe 'A user can subscribe', type: :feature, js: true do

  before do
    confirmed_user = create(:user, confirmation: true)
    id = User.first.id
    visit "/users/#{id}/subscribe"
  end

  it 'by visiting the subscription page displays a "Pay with Card" option' do
    expect(page).to have_content 'Pay with Card'
  end

  it 'by clicking the "Pay with Card" button displays a "Pay" button' do
    click_button 'Pay with Card'
    expect(page).to have_content 'Pay £'
  end

  it 'by paying with a valid credit card' do
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Pay with Card'
    expect(page).to have_content 'Pay £'
  end

end
