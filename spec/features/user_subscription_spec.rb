describe 'Subscribing', type: :feature, js: true do

  RSpec.configure do |config|
    config.before(:each) do
      page.driver.allow_unknown_urls # capy webkit - silences warnings
    end
  end

  before do
    confirmed_user = create(:user, confirmation: true)
  end

  context 'a confirmed user' do
    context "by visiting the subscription page" do
      it 'displays a "Pay with Card" button' do
        visit '/subscribe'
        expect(page).to have_button 'Pay with Card'
      end

      context 'and selecting "Pay with Card"' do
        it 'displays the Stripe checkout form' do
          visit '/subscribe'
          click_button 'Pay with Card'
          expect(page).to have_content 'Pay £512.50'
        end

        context "making a successful payment" do
          it 'will be directed to the charge page' do
            user = User.first
            visit '/subscribe'
            click_button 'Pay with Card'
            fill_in 'email', with: 'medff@test.com'
            fill_in 'card_number', with: '4242424242424242'
            fill_in 'cc-exp', with: '1215'
            fill_in 'cc-csc', with: '123'
            click_button 'Pay £512.50'
            expect(page).to have_content ''
          end
        end
      end
    end
  end

end
