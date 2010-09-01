class Admin::AnnouncementsController < ApplicationController
  before_filter :login_required
  before_filter :find_announcement, :only => [:edit, :update, :destroy]
  layout "admin"
  
  def index
    @announcements = Announcement.all
  end

  def new
    @announcement = Announcement.new
  end

  def edit
  end

  def show

  end

  def create
    @announcement = Announcement.new(params[:announcement])

    if @announcement.save
      redirect_to admin_announcements_path, :notice => "Successfully created announcement"
    else
      render 'new'
    end
  end

  def update
    if @announcement.update_attributes(params[:announcement])
      redirect_to admin_announcements_path, :notice => "Voice successfully updated"
    else
      render 'edit'
    end
  end

  def destroy
    @announcement.destroy

    redirect_to admin_announcements_path
  end

  private

  def find_announcement
    @announcement = Announcement.find(params[:id])
  end

end
