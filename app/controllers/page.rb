Padfoot::App.controllers :page do

  get :contact , map: '/contact' do
    render :contact
  end

  get :home, map: '/' do
    render :home
  end

end
