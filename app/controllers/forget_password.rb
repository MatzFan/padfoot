Padfoot::App.controllers :forget_password do

  get :new, map:'/password_forget' do
    render 'new'
  end

  post :create do
    user = User.first(email: params[:email])
    if user
      user.send(:save_forget_password_token) # use send, as private method
      link = 'http://localhost:9292' + url(:forget_password, :edit,
        token: user.password_reset_token)
      deliver(:password_reset, :password_reset_email, user, link)
    end
    render 'success' # always - give no indication of whether email exists..
  end

  get :edit, map: "/password_reset/:token/edit" do
    # @user = User.first(password_reset_token: params[:token])
    # if @user.password_reset_sent_date <= Time.now + (60 * 60)
    #   @user.update({ password_reset_token: 0, password_reset_sent_date: 0 })
    #   flash[:error] = 'Password reset token has expired.'
    #   redirect url(:sessions, :new)
    # elsif @user
    #   render 'edit'
    # else
    #   @user.update({ password_reset_token: 0, password_reset_sent_date: 0 })
    #   redirect url(:password_forget, :new)
    # end
  end

end
