class Link < Content
  has_attached_file :preview, ({
    :styles => { :original => '260x260>', :thumb_wdgt => '53x49#' },
    :default_url => PageParser::DEFAULT_IMAGE, 
  }).merge(rackspace_cdn_settings)
  
  before_validation :fetch_title_and_image!, :unless => "url.blank?", :on => :create
  validate :couldnt_fetch_data, :on => :create
  validates :thumbnail_url,
    :presence => true
  validates :page_title,
    :presence => true
  validates :width,
    :presence => true#, :if => :should_validate_dimensions?
  validates :height,
    :presence => true#, :if => :should_validate_dimensions?
  
  def couldnt_fetch_data
    errors.add(:url, :invalid) if @has_invalid_url_error
  end

  # Overwrites thumbnail height for links with 100px of width
  def thumbnail_height
    default_thumbnail? ? thumbnail_width / aspect : 100 / aspect
  end
  
  def thumbnail_width
    default_thumbnail? ? width : 100 * aspect
  end
  
  # Handle preview.url
  def preview_url_or_default
    preview.file? ? preview.url : self[:thumbnail_url]
  end
  
  def images
    @images || []
  end
  
  private

  def get_thumbnail_dimensions
    dimensions = Image.dimensions(@fetched_image ? @fetched_image : thumbnail_url)
    self.width = dimensions[:width]
    self.height = dimensions[:height]
  end

  def default_thumbnail?
    thumbnail_url =~ /link-default\.png$/ || thumbnail_url =~ /link-icon\.gif$/
  end
  
  # Sets default icon url to thumbnail_url
  def save_default_thumbnail
    if preview.file?
      preview.flush_writes
      preview.destroy
    end
    self.thumbnail_url = PageParser::DEFAULT_IMAGE
  end

  # Saves the external thumbnail url to a local file and store it as the thumbnail
  def fetch_thumbnail
    begin
      if !default_thumbnail?
        @fetched_image = Image.fetch_remote_image(thumbnail_url)
        if @fetched_image.nil?
          save_default_thumbnail
        else
          self.preview = @fetched_image
        end
      end
    rescue # timeout error, or ImageMagick's identify error
      save_default_thumbnail
    end
  end

  # TODO: catch a specific Exception
  def fetch_title_and_image!
    begin
      page = PageParser.parse(url)
      self.thumbnail_url = page.first_image if thumbnail_url.blank?
      self.page_title = page.title if page_title.blank?
      self.page_content = page.description if page_content.blank?

      fetch_thumbnail
      get_thumbnail_dimensions
    rescue
      # couldn't connect to url
      @has_invalid_url_error = true
      false
    end
  end

end
