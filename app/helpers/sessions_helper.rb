# Helper methods defined here can be ACCESSED IN ANY CONTROLLER OR VIEW IN THE APPLICATION!!!!!!!!

module SessionsHelper

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User[session[:current_user]]
  end

  def sign_in(user)
    session[:current_user] = user.id
    self.current_user = user
  end

  def sign_out
    session.delete(:current_user)
  end

  def signed_in? # critical method used throughout for access control :))
    !current_user.nil?
  end

end

Padfoot::App.helpers SessionsHelper
