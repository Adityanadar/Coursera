class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?
  before_action :ensure_login
  
  def logged_in?
	  current_user != nil
  end
  
  def current_user
	  @current_user ||= User.find_by_id(session[:current_user_id])
  end
  
  def ensure_login
	  unless logged_in?
	  	redirect_to login_path
	  end
  end
  
end
