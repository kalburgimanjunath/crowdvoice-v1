class Video < Content
  has_attached_file :preview, ({
    :styles => { :original => '260x260>', :thumb_wdgt => '53x49#' }
  }).merge(rackspace_cdn_settings)
  
  before_create :fetch_thumbnail
  after_create :save_image_dimensions

  # Detects if the source of the url is from
  # :youtube, :vimeo or :unknown
  def network
    case url
    when /^https?:\/\/(?:www\.)?youtube\.com*/
      :youtube
    when /^https?:\/\/(?:www\.)?vimeo\.com*/
      :vimeo
    end
  end

  # Gets the video id from the url depending on the network
  def video_id
    case network
    when :youtube
      url.match(/v=([^&]*)/).captures.first
    when :vimeo
      url.match(/(?:.*#)?(\d+)/).captures.first
    end
  end

  private

  def fetch_thumbnail
    info = nil

    case network
    when :youtube
      info = YoutubeParser::Video.fetch_info(video_id)
    when :vimeo
      info = VimeoParser::Video.fetch_info(video_id)
    end

    unless info.nil?
      self.page_title = info.title
      self.thumbnail_url = info.image
      str = NetRequest.get(thumbnail_url)
      tmp = Tempfile.new("#{video_id}.jpg")
      tmp.write str
      self.preview = tmp
    end
  end

end
