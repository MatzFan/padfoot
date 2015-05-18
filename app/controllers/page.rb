Padfoot::App.controllers :page do

  get :home, map: '/' do
    render :home
  end

  get :contact , map: '/contact' do
    render :contact
  end

  get :subscribe, map: '/subscribe' do
    @user = User[params[:id].to_i]
    render :subscribe
  end

  post :charge, map: '/charge' do
    @amount = 51250

    customer = Stripe::Customer.create(
      :email => 'a.user.com',
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :amount      => 50000,
      :description => 'Test Charge',
      :currency    => 'gbp',
      :customer    => customer.id
    )

    render '/payment'
  end

  get :payment, map: '/payment' do
    render :payment
  end

end
