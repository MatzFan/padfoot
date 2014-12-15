Padfoot::App.controllers :forget_password do

  get :new, map:'/password_forget' do
    render 'new'
  end

  post :create do
    user = User.find(email: params[:email])
    if user
      user.save_forget_password_token
      link = 'http://localhost:9292' + url(:forget_password, :edit,
        :token => user.password_reset_token)
      deliver(:password_forget, :password_forget_email, user.email, link)
    end
    render 'success' # always - give no indication of whether email exists..
  end


end
