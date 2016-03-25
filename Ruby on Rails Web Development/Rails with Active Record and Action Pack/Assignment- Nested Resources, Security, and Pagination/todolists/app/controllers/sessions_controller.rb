class SessionsController < ApplicationController
  skip_before_action :ensure_login, only: [:new, :create]
  
  
  def new
  end

  def create
	  user = User.find_by_username(session_params[:username])

	  if user && user.authenticate(session_params[:password])
	  	session[:current_user_id] = user.id
	  	redirect_to root_path, notice: 'Logged in successfully'
	  else
	  	redirect_to login_path, alert: 'Could not log in. Please try again'	  
	  end

  end

  def destroy
	  session[:current_user_id] = nil
	  redirect_to login_path, notice: 'Logged out successfully'
  end
  
  private
  	def session_params
		params.require(:user).permit(:username, :password)
	end
  
  
  
end
