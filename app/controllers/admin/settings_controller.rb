class Admin::SettingsController < ApplicationController
  before_filter :login_required
  before_filter :admin_required
  layout "admin"
  
  def index
  end

  def create
    settings = params[:settings]

    settings.collect do |key, value|
     Settings[key.to_sym] = value
    end

    redirect_to admin_settings_path, :notify => "Settings succesfully updated!"
  end
end
