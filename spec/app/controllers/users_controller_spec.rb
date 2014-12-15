require 'spec_helper'

RSpec.describe "/users" do

  describe "GET confirm" do

    let(:user) { create(:user) }
    let(:id) { user.id }
    let(:code) { user.confirmation_code }

    it "render the 'users/confirm' page if user has confirmation code" do
      get "/confirm/#{id}/#{code}"
      expect(last_request.path).to eq("/confirm/#{id}/#{code}")
    end

    it "redirect the :confirm if user id is wrong" do
      get "/confirm/test/#{user.confirmation_code}"
      expect(last_response).to be_redirect
    end

    it "redirect to :confirm if confirmation_code is wrong" do
      get "/confirm/#{user.id}/test"
      expect(last_response).to be_redirect
    end
  end

  describe "GET edit" do
    let(:user) { build(:user) }

    it "redirects if wrong id" do
      get "/users/-1/edit"
      expect(last_response).to be_redirect
    end

    it "render the view for editing a user" do
      user.save
      id = user.id
      get "/users/#{id}/edit"
      expect(last_response).to be_ok
    end
  end

  describe 'PUT update' do

    let(:user) { build(:user) }

    it 'successful updates should be saved' do
      user.save
      id = user.id
      put "users/#{id}", user: { name: 'new' }# :user param is data to update
      expect(User[id].name).to eq('new')
    end

    it 'successful updates should redirect' do
      user.save
      id = user.id
      put "users/#{id}", user: { name: 'new' }
      expect(last_response).to be_redirect
    end

    it 'stays on the page if the user has made input errors' do
      user.save
      id = user.id
      put "users/#{id}", user: { name: '' } # invalid (empty)
      expect(last_response).to be_ok
    end
  end

end
