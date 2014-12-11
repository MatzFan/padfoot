Padfoot::App.controllers :page do

  get :about, map: '/about' do
    render :about
  end

  get :contact , map: '/contact' do
    render :contact
  end

  get :home, map: '/' do
    render :home
  end

end
