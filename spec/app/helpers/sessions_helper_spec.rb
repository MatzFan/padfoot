describe SessionsHelper do
  before do
    class SessionsHelperClass
      include SessionsHelper
    end
    @session_helper = SessionsHelperClass.new
  end

  context "#current_user" do
    it 'output the current user if current user is already set' do
      user = build(:user)
      browser = Rack::Test::Session.new(Padfoot::App)
      browser.get '/', {}, 'rack.session' => { current_user: nil }
      allow(@session_helper).to receive(:current_user=).with(user)
      allow(@session_helper).to receive(:last_request).and_return(browser.last_request)
      expect(@session_helper.current_user) == user
    end

    it 'output the user by id from the current session' do
      create(:user)
      user = User.first
      browser = Rack::Test::Session.new(Padfoot::App)
      browser.get '/', {}, 'rack.session' => { current_user: nil }
      allow(@session_helper).to receive(:sign_in).with(user)
      allow(@session_helper).to receive(:last_request).and_return(browser.last_request)
      expect(@session_helper.current_user) == user
    end

    it "returns false if a user is not logged in" do
      browser = Rack::Test::Session.new(Padfoot::App)
      browser.get '/', {}, 'rack.session' => { current_user: nil }
      allow(@session_helper).to receive(:last_request).and_return(browser.last_request)
      expect(@session_helper.current_user).to be_falsy
    end
  end

  context "#sign_in" do
    it "it sets the current user to the signed in user" do
      create(:user)
      user = User.first
      browser = Rack::Test::Session.new(Padfoot::App)
      browser.get '/', {}, 'rack.session' => { current_user: nil } # none signed in
      allow(@session_helper).to receive(:sign_in).with(user)
      allow(@session_helper).to receive(:last_request).and_return(browser.last_request)
      expect(@session_helper.current_user) == user
    end
  end

  context "#signed_in?" do
    it "return false if no user is logged in" do
      browser = Rack::Test::Session.new(Padfoot::App)
      browser.get '/', {}, 'rack.session' => { current_user: nil }
      allow(@session_helper).to receive(:last_request).and_return(browser.last_request)
      expect(@session_helper.signed_in?).to eq(false)
    end

    it "return true if a user is logged in" do
      create(:user)
      user = User.first
      browser = Rack::Test::Session.new(Padfoot::App)
      browser.get '/', {}, 'rack.session' => { current_user: user.id }
      allow(@session_helper).to receive(:last_request).and_return(browser.last_request)
      expect(@session_helper.signed_in?).to eq(true)
    end

  end
end
