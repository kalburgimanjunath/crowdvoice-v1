class VoicesController < ApplicationController
  before_filter :find_voice, :only => [:show]
  before_filter :find_voice_announcements, :only => [:show]
  layout :find_layout

  def index
    if params[:search].blank?
      @voices = Voice.visible
      @all_voices = find_all_voices
      @grouped_voices = Voice.all.group_by(&:location).map do |loc, voices|
        { loc => voices.map { |l| { :slug => l.slug, :title => l.title, :latitude => l.latitude, :longitude => l.longitude } }}
      end.to_json
    else
      @search = params[:search]
      @voices = Voice.paginate :page => params[:page],
                               :conditions => ['title LIKE ?', "%#{params[:search]}%"],
                               :order => 'title'
      render :action => "search", :layout => false
    end
  end

  def all
    @voices = Voice.paginate :page => params[:page], :order => 'title'
  end
  
  def show
    session[:show_unapproved] = 1 if params[:u]
    filter_contents = @voice.contents.filter_and_limit(session[:show_unapproved], params)
    current_offset = (params[:offset] || 0).to_i
    offset = current_offset * Settings.posts_per_page.to_i
    next_contents_offset = current_offset.succ * Settings.posts_per_page.to_i
    @contents = filter_contents.limit(Settings.posts_per_page).offset(offset).all
    @last = next_contents_offset >= filter_contents.size
    @all_voices = find_all_voices
  end
  
  def search
    
  end
  
  private

  def find_voice
    @voice = Voice.find_by_slug!(params[:id])
  end

  def find_layout
    if action_name == 'index' && (!params[:search] || (params[:search] && params[:search].strip.blank?))
      'homepage'
    elsif action_name == 'all' || (params[:search] && !params[:search].strip.blank?)
      'search'
    else
      'voices'
    end
  end

  def find_voice_announcements
    @announcements = @voice.announcements
  end

  def find_all_voices
    _voices = Voice.order('title ASC')
    
    half = (_voices.count / 2)
    
    [_voices[0..half], _voices[half+1.._voices.count]]
  end
end
