Padfoot::App.controllers :page do
  get :home, map: '/' do
    render :home
  end

  get :contact, map: '/contact' do
    render :contact
  end
end
