class Link < Content
  has_attached_file :preview, ({
    :styles => { :original => '260x260>', :thumb_wdgt => '53x49#' },
    :default_url => PageParser::DEFAULT_IMAGE, 
  }).merge(rackspace_cdn_settings)
  
  before_validation :fetch_title_and_image!, :unless => "url.blank?", :on => :create
  validate :couldnt_fetch_data, :on => :create
  after_create :fetch_thumbnail, :unless => :default_thumbnail?
  after_create :save_image_dimensions
  validates :thumbnail_url,
    :presence => true
  validates :page_title,
    :presence => true
  validates :width,
    :presence => true, :if => :should_validate_dimensions?
  validates :height,
    :presence => true, :if => :should_validate_dimensions?
  
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
  
  # Overrides method to handle preview.url
  def thumbnail_url
    preview.file? ? preview.url : self[:thumbnail_url]
  end
  
  def images
    @images || []
  end
  
  private

  def default_thumbnail?
    thumbnail_url =~ /link-default\.png$/ || thumbnail_url =~ /link-icon\.gif$/
  end
  
  # Sets default icon url to thumbnail_url
  def save_default_thumbnail
    preview.flush_writes
    preview.destroy
    self.thumbnail_url = PageParser::DEFAULT_IMAGE
  end

  # Saves the external thumbnail url to a local file and store it as the thumbnail
  def fetch_thumbnail
    thurl = thumbnail_url
    begin
      if !thumbnail_url.blank? && !default_thumbnail?
        self.preview = Image.fetch_remote_image(thumbnail_url)
        save_default_thumbnail unless valid? # FIXME: Find the way to trigger identify error
      else
        save_default_thumbnail
      end
    rescue # timeout error, or ImageMagick's identify error
      save_default_thumbnail
    end
    # FIXME
    save || (save_default_thumbnail and save!)
  end

  # TODO: catch a specific Exception
  def fetch_title_and_image!
    # if we didn't receive any info, force parsing
    if self.page_title.blank? || self.page_content.blank? || self.thumbnail_url.blank?
      begin
        page = PageParser.parse(url)
        self.thumbnail_url = page.first_image
        self.page_title = page.title
        self.page_content = page.description if page_content.blank?
      rescue
        # couldn't connect to url
        @has_invalid_url_error = true
        false
      end
    end
    
  end

end
