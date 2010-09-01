class UserSessionsController < ApplicationController  
  layout "admin"
  
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      if session[:back]
        url = session[:back]
        session[:back] = nil
      else
        url = root_path
      end
      redirect_to url, :notice => "Succesfully logged in"
    else
      render 'new'
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    redirect_to root_path
  end
end
