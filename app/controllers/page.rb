Padfoot::App.controllers :page do

  get :about, map: '/about' do
    render :haml, 'about'
  end

  get :contact , map: '/contact' do
    render :haml, 'contact'
  end

  get :home, map: '/' do
    render :haml, 'home'
  end

end
