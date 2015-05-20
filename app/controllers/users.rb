Padfoot::App.controllers :users do

  before :edit, :update  do
    redirect('/login') unless signed_in?
    @user = User[params[:id].to_i]
    redirect('/login') unless current_user == @user
  end

  get :new, map: '/register' do
    @user = User.new
    render :new
  end

  post :create do
    @user = User.new(params[:user])
    if @user.save
      deliver(:confirmation, :confirmation_email,
        @user.name,
        @user.email,
        @user.id,
        @user.confirmation_code) unless @user.confirmation # check confirmed
      flash[:notice] = 'Message sent'
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
    @user.set(params[:user]) # CAN'T USE #update in if, as it returns false!
    if @user.save
      flash[:notice] = 'You have updated your profile.'
      redirect('/')
    else
      flash[:error] = 'Your profile was not updated.'
      render :edit
    end
  end

  get :subscribe, map: '/users/:id/subscribe' do
    @user = User[params[:id].to_i]
    render :subscribe
  end

  post :payment_confirmation, map: '/users/:id/payment_confirmation' do
    @user = User[params[:id].to_i]
    stripe_cust_id = @user.stripe_cust_id

    if stripe_cust_id
      customer = Stripe::Customer.retrieve(stripe_cust_id)
    else
      customer = Stripe::Customer.create(card: params[:stripeToken])
    end

    charge = Stripe::Charge.create(
      :amount      => annual_subscription_cost_pence, # stripe_helper method
      :description => 'Test Charge',
      :currency    => 'gbp',
      :customer    => customer.id
    )
    @user.update(subscription: true, stripe_cust_id: customer.id)
    flash[:notice] = 'You have successfully subscribed, please log in'
    redirect '/login'
  end

end
