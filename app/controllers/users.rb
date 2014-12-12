Padfoot::App.controllers :users do

  get :new, map: "/login" do
    @user = User.new
    render :new
  end

  post :create do
    @user = User.new(params[:user])
    @user.save ? redirect('/') : render(:new) # save triggers validations
  end

end
