class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?

  private
  
  # Returns the current session, if any
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  protected
  
  # Return a short URL
  def shorten_url(url)
    if Rails.env.production?
      NetRequest.get "http://is.gd/api.php?longurl=#{CGI.escape(url)}"
    else
      url
    end
  end
  
  # Returns true if there is a current user logged in
  def logged_in?
    !current_user.nil?
  end

  # Returns the current logged in user
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  # ===========
  # = Filters =
  # ===========
  
  # Requires the user to be logged in
  def login_required
    unless logged_in?
      session[:back] = request.fullpath
      flash.now[:alert] = "You need to log in first."
      redirect_to login_path
    end
  end
  
  # Requires the current logged in user to be an administrator
  def admin_required
    unless current_user.admin?
      flash.now[:alert] = "You need to be an administrator to do this."
      redirect_to root_path
    end
  end
end
