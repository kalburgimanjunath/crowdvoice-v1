class ContentsController < ApplicationController
  caches_page :index
  cache_sweeper :content_sweeper, :only => [:update, :reset_score, :vote, :destroy]

  verify :params => "voice_id",
    :redirect_to => :back,
    :add_flash => { :alert => "Content can be accesed only through voices." },
    :except => [:index, :remote_page_info]

  before_filter :login_required, :except => [:index, :create, :vote, :remote_page_info]
  before_filter :find_voice, :except => [:index, :remote_page_info]
  before_filter :check_voice_mode, :only => :create
  before_filter :find_content, :only => [
    :edit, :update, :destroy,
    :reset_score, :vote
  ]

  def index
    @contents = Content.approved
  end

  def create
    @content = @voice.build_content_from_url(params[:content].delete(:url), params[:content])

    if @content
      if @content.link?
        @content.page_title = params[:link_title]
        @content.page_content = params[:content][:page_content] || params[:link_description]
        @content.thumbnail_url = params[:link_image]
      end
      
      unless @content.save
        @error = @content.errors.full_messages.to_sentence
      end
    else
      @error = "URL doesn't exist or is invalid."
    end
    
    respond_to do |format|
      format.js { render :content_type => "text/javascript" }
      format.html { redirect_to @voice, :notice => "Content successfully created." }
    end
  end

  def edit
  end

  def update
    if @content.update_attributes(params[:content])
      redirect_to [@voice, @content], :notice => "Content successfully updated."
    else
      render 'edit'
    end
  end

  def destroy
    @content.destroy
    redirect_to @voice, :notice => "Content deleted"
  end

  # Resets the votes for a content so it appears as unapproved again.
  def reset_score
    @content.reset_score!
    redirect_to @voice, :notice => "Score reseted."
  end

  # Adds a vote to the content with passed rating
  def vote
    rating = params[:rating] == "up" ? 1 : -1
    vote = @content.votes.build(:ip_address => request.remote_ip, :rating => rating)

    if vote.save
      @content.update_attribute(:approved, !!(vote.rating >= Settings.approved_threshold.to_i))

      @content.reload
    else
      @error = vote.errors[:base].first
    end
  end

# # Updates the url for a link's image
# #
# # TODO: Security warning, anybody can change images. since users
# # don't need to login to post links.
# #
# # This is defninitely an issue that needs to be taken care off.
# # but we will leave it as it is for now, because of time limitations.
# #
# def update_url
#   jr, id, url = JsonResponse.new, params[:id], params[:url]
#   return render(:text => jr.to_js('test')) unless Content.exists?(id)
#   return render(:text => jr.to_js('test')) unless url
#   Link.find(id).update_attribute(:thumbnail_url, url)
#   jr.positive
#   render :text => jr.to_js('test')
# end

  #
  #
  #
  def remote_page_info
    url = params[:url]
    info = {}
    if url
      page = PageParser.parse(url)

      info[:title] = page.title
      info[:description] = page.description
      info[:images] = page.images
    end
    render :json => info
  end

  private

  def find_voice
    @voice = Voice.find_by_slug(params[:voice_id])
  end

  def find_content
    @content = @voice.contents.find(params[:id])
  end

  # Prevents public submission if voice mode is set to 'Stop'
  def check_voice_mode
    if !@voice.allow_posting? && !logged_in?
      flash[:alert] = "Voice does not allow more submissions."
      redirect_to @voice
    end
  end

end
