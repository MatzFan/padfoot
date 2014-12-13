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

end
