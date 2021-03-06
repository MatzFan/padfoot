Padfoot::App.controllers :sessions do
  get :new, map: '/login' do
    render :new, locals: { error: false }
  end

  post :create, map: '/create' do
    @user = User.find(email: params[:email])
    if @user && @user.confirmation && @user.password == params[:password]
      if @user.subscription
        if params[:remember_me]
          @user.authenticity_token = SecureRandom.hex
          thirty_days_in_seconds = 30 * 24 * 60 * 60
          response.set_cookie('permanent_cookie', value:
                                        { domain: 'jerseypropertyservices.com', path: '/'},
                                        max_age: "#{thirty_days_in_seconds}")
          @user.save
        end
        flash[:notice] = "Welcome back #{@user.name.split(' ').first}."
        sign_in(@user) # defined in helpers/sessions
        redirect 'applications/index'
      else
        redirect "users/#{@user.id}/subscribe"
      end
    else
      render :new, locals: { error: true }
    end
  end

  get :destroy, map: '/logout' do
    sign_out
    flash[:notice] = 'You have successfully logged out.'
    redirect '/'
  end
end
