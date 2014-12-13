Padfoot::App.controllers :users do

  get :new, map: '/login' do
    @user = User.new
    render :new
  end

  post :create do
    @user = User.new(params[:user])
    if @user.save
      deliver(:registration, :registration_email, @user.name, @user.email)
      deliver(:confirmation, :confirmation_email, @user.name,
            @user.email,
            @user.id,
            @user.confirmation_code)
      redirect('/')
    else
      render :new # refresh the page (with warnings)
    end
  end

  get :confirm, map: '/confirm/:id/:code' do
    redirect('/') unless @user = User[params[:id].to_i] # if user is nil
    pp @user
    puts params[:code]
    redirect('/') unless @user.authenticate(params[:code].to_s)
    render :confirm
  end

end
