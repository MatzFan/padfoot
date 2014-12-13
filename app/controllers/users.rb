Padfoot::App.controllers :users do

  get :new, map: "/login" do
    @user = User.new
    render :new
  end

  post :create do
    @user = User.new(params[:user])
    if @user.save
      deliver(:registration, :registration_email, @user.name, @user.email)
      redirect('/')
    else
      render :new # refresh the page (with warnings)
    end
  end

  get :confirm, map: '/confirm/:id/:code' do
    @user = User[params[:id.to_s.to_i]]
    redirect('/') unless @user = User[params[:id.to_s.to_i]] # if user is nil
    redirect('/') unless @user.authenticate(params[:code])
    render 'confirm'
  end

end
