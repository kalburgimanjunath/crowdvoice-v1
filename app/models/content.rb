class Content < ActiveRecord::Base
  include RackspaceCdnSettings

  belongs_to :voice
  has_many :votes, :dependent => :destroy

  validates :voice_id,
    :presence => true
  validates :url,
    :presence => true,
    :url => {
      :message => "URL is invalid",
    },
    :uniqueness => {
      :scope => :voice_id,
      :message => "Thanks for participating, but the content is already in the voice. Try a different image, video or link."
    }

  scope :approved, where(:approved => true)
  scope :unapproved, where(:approved => false)
  scope :digest, where("created_at BETWEEN ? AND ?", Time.now.utc.beginning_of_day, Time.now.utc.end_of_day)

  # Filters contents by content type and limit them by week, month or all
  def self.filter_and_limit(show_unapproved, params)
    filter_param = params[:filter]
    limit_param = params[:limit]

    contents = if show_unapproved
      where({})
    else
      approved
    end
    contents = contents.where(:type => filter_param) if filter_param
    contents = contents.where(:created_at => (limit_param.to_i.days.ago..DateTime.now)) if limit_param && limit_param.to_i != 0
    contents
  end
  
  # Resets content's votes to zero
  def reset_score!
    votes.destroy_all
    update_attributes({
      :approved => false,
      :positive_votes_count => 0,
      :negative_votes_count => 0,
      :overall_score => 0
    })
  end

  # Returns true if content_type is a Link
  def link?
    is_a? Link
  end

  # Returns true if content_type is a Image
  def image?
    is_a? Image
  end

  # Returns true if content_type is a Video
  def video?
    is_a? Video
  end

  # Builds an instance of the content based on its content type detected by the URL.
  def self.build_from_url(url, attrs = {})
    url.strip!
    url = "http://#{url}" unless /http:\/\/.*/ =~ url

    type = detect_type(url)
    type.new(attrs.merge(:url => url)) if type
  end

  # Detects the content type based on the url.
  def self.detect_type(url)
    return nil if !(UrlValidator::URL_REGEX =~ url) || !NetRequest.valid_url?(url)

    if is_a_video? url
      Video
    elsif is_an_image? url
      Image
    else
      Link
    end
  end

  # Gets thumbnail exact height for 260px,
  # which is the width of the container in the view
  def thumbnail_height
    260 / aspect
  end

  # Calculates aspect ratio for image
  def aspect
    width.to_f / height.to_f
  end

  protected

  # Saves width and height for the passed file
  def setup_width_and_height(file)
    self.update_attributes Image.dimensions(file)
  end

  private

  # Detects if the Content-Type header of the url is an image
  # Or if the host is a known image hosting.
  #
  # == Valid image hostings:
  #
  # * twitpic.com
  # * flickr.com
  def self.is_an_image?(url)
    flickr_regex = /^https?:\/\/(?:www\.)?flickr\.com\/photos\/[-\w@]+\/\d+/i
    twitpic_regex = /^https?:\/\/(?:www\.)?twitpic\.com\/\w+/i
    img_regex = /\.(jpe?g|png|gif)$/i
    url =~ flickr_regex || url =~ twitpic_regex || url =~ img_regex
  end

  # Detects if the Content-Type header of the url is a video
  # Or if the host is a known video hosting.
  #
  # == Valid video hostings:
  #
  # * vimeo.com
  # * youtube.com
  def self.is_a_video?(url)
    yt_regex = /^https?:\/\/(?:www\.)?youtube\.com\/watch\?v=[^&]/i
    vimeo_regex = /^https?:\/\/(?:www\.)?vimeo\.com\/(?:.*#)?(\d+)/i
    url =~ yt_regex || url =~ vimeo_regex
  end

  # Fetchs the content type from the headers of the URL
  def self.content_type(uri)
    NetRequest.get_response(uri).content_type
  end

  # Content dimension setup
  #
  # TODO: Decide what to do with inappropriate links
  #
  # NOTE: At the moment we are deleting images that can not be parsed.
  # For example, if someone gives us a link for an image, but it
  # returns a 404, or a 500 error page.
  #
  # Alternatives that I tought here were:
  #
  def save_image_dimensions
    begin
      attempt_to_save_image_dimensions_from_remote(thumbnail_url)
    rescue Paperclip::NotIdentifiedByImageMagickError
      attempt_to_save_image_dimensions_from_remote(PageParser::DEFAULT_IMAGE)

      #   - let the image enter the system, with a default image for
      #     display and a description that says "Invalid link."
      # self.update_attributes(:description => 'Invalid link.')

      #   - or simply delete the given image and let the user try again.
      # self.destroy

      #   - just let the link enter the system with no image.
      # (this is what we are doing!)

    end
  end

  def attempt_to_save_image_dimensions_from_remote(file)
    # path = if URI(file).absolute?
    #   image = Image.fetch_remote_image(file)
    #   if image.nil?
    #     self.thumbnail_url = PageParser::DEFAULT_IMAGE
    #   else
    #     image.close
    #     image.path
    #   end
    # else
    #   file
    # end
    setup_width_and_height file
  end

end
