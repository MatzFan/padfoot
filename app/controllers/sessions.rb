Padfoot::App.controllers :sessions do

  get :new, map: '/login' do
    render :new, locals: { error: false }
  end

  post :create, map: '/create' do
    @user = User.find(email: params[:email])
    if @user && @user.confirmation && @user.password == params[:password]
      sign_in(@user) # defined in helpers/sessions
      redirect '/'
    else
      render :new, locals: { error: true }
    end
  end

  get :destroy, map: '/logout' do
    sign_out
    redirect '/'
  end

end
