require 'delayed_feed/rss_feed_job'

class Admin::VoicesController < ApplicationController
  before_filter :login_required
  before_filter :admin_required
  before_filter :find_voice, :only => [:show, :edit, :update, :destroy]
  cache_sweeper :static_page_sweeper, :only => [:create, :update, :destroy]
  layout "admin"
  
  def fetch_feeds
    Delayed::Job.enqueue DelayedFeed::RssFeedJob.new
    flash[:notice] = "Application is now fetching the RSS feeds"
    redirect_to :action => 'index'
  end

  def index
    @voices = Voice.all
  end

  def new
    @voice = Voice.new
  end

  def show
  end

  def create
    @voice = current_user.voices.build(params[:voice])
    if @voice.save
      # if params[:voice][:background_image].blank?
        redirect_to @voice, :notice => "Voice successfully created"
      # else
      #   render 'crop'
      # end
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @voice.update_attributes(params[:voice])
      if params[:voice][:background_image].blank?
        redirect_to @voice, :notice => "Voice successfully updated"
      else
        render 'crop'
      end
    else
      render 'edit'
    end
  end

  def destroy
    @voice.destroy
    redirect_to admin_voices_path
  end

  private

  def find_voice
    @voice = Voice.find_by_slug(params[:id])
  end
end
