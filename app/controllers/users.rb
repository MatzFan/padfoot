Padfoot::App.controllers :users do

  before :edit, :update  do
    redirect('/login') unless signed_in?
    @user = User[params[:id].to_i]
    redirect('/login') unless current_user == @user
  end

  get :new, map: '/login' do
    @user = User.new
    render :new
  end

  post :create do
    @user = User.new(params[:user])
    if @user.save
      deliver(:registration, :registration_email, @user.name, @user.email)
      deliver(:confirmation, :confirmation_email,
            @user.name,
            @user.email,
            @user.id,
            @user.confirmation_code) unless @user.confirmation# check confirmed
      redirect('/')
    else
      render :new # refresh the page (with warnings)
    end
  end

  get :confirm, map: '/confirm/:id/:code' do
    redirect('/') unless @user = User[params[:id].to_i] # if user is nil
    redirect('/') unless @user.authenticate(params[:code].to_s)
    render :confirm
  end

  get :edit, map: '/users/:id/edit' do
    @user = User[params[:id].to_i]
    render :edit
  end

  put :update, map: '/users/:id' do
    @user = User[params[:id].to_i]
    if @user == nil
      flash[:error] = 'User is not registered.'
      render :edit
    end
    @user.set(params[:updates]) # CAN'T USE #update in if, as it returns false!
    if @user.save
      flash[:notice] = 'You have updated your profile.'
      redirect('/')
    else
      flash[:error] = 'Your profile was not updated.'
      render :edit
    end
  end

end
