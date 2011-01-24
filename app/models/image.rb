class Image < Content
  has_attached_file :mailed_attachment, ({
    :styles => { :thumb => '260x260>' }
  }).merge(rackspace_cdn_settings)
  
  has_attached_file :preview, ({
    :styles => { :thumb => '260x260>', :thumb_wdgt => '53x49#' }
  }).merge(rackspace_cdn_settings)

  before_create :fetch_thumbnail, :if => "!url.blank?"
  before_create :update_title
  after_create :set_dimensions, :setup_imap_urls

  def resolve_domain
    return 'http://127.0.0.1:3000' unless Rails.env == 'production'
    ''
  end

  def resolve_url(symbol = :original)
    resolve_domain + self.mailed_attachment.url(symbol).gsub(/\?.*/, '')
  end

  def setup_imap_urls
    if self.emailed_from.present?
      self.update_attributes(
        :url => resolve_url(:original),
        :image_url => resolve_url(:original),
        :thumbnail_url => resolve_url(:thumbnail_url)
      )
    end
  end

  # Detects if the source of the url is from
  # :twitpic, :flickr or :unknown
  def network
    case url
    when /^https?:\/\/(?:www\.)?twitpic\.com*/
      :twitpic
    when /^https?:\/\/(?:www\.)?flickr\.com*/
      :flickr
    else
      :unknown
    end
  end

  # Gets the image id from the url depending on the network
  def image_id
    case network
    when :twitpic
      url.match(/twitpic\.com\/(.*)/).captures.first
    when :flickr
      url.match(/\/photos\/.*\/(\d+)(?:\/.*)?$/).captures.first
    end
  end

  # Image pretty name generator
  #
  # The basename of the URL without the extention
  #
  # eg: http://www.path.to/someimage.jpg => someimage
  #
  #  ==== Returns
  #  - string
  #
  def pretty_name
    File.basename(self.url, File.extname(self.url))
  end

  # Gets dimensions from a image file.
  #
  #  ==== Returns
  #  - hash, array
  #
  #  ==== Usage
  #
  #  <code>
  #
  #    # Extract dimensions as a hash
  #    Image.dimensions '/Users/kazu/Desktop/haruhi_cutie.jpg'
  #      #=> {:width=>333.0, :height=>375.0}
  #
  #    # Extract dimensions as an array
  #    Image.dimensions '/Users/kazu/Desktop/haruhi_cutie.jpg', false
  #      #=> [333.0, 375.0]
  #
  #    # Extract dimensions and assing values to variables
  #    width, height = Image.dimensions '/../file.jpg', false
  #
  #    # Extract dimensions and update a model
  #    self.update_attributes Image.dimensions(file)
  #
  #    # Extract dimensions and update a model with different column names?
  #    self.update_attributes Image.dimensions(file, true, [:my_width, :my_height])
  #
  #  <code>
  #
  def self.dimensions(file, hash = true, keys = [:width, :height])
    geometry = Paperclip::Geometry.from_file(file)
    return [geometry.width, geometry.height] unless hash
    { keys.first => geometry.width, keys.second => geometry.height }
  end
  
  # Saves remote image url to a local tmp file
  def self.fetch_remote_image(url)
    img = rio(url).binmode
    tmp = rio("#{Dir.tmpdir}/#{img.filename}")
    img > tmp
    File.open(tmp.path)
  end

  # Extracts the extension of the image url or jpg by default
  def self.extract_basename_and_extension(url)
    basename, ext = url.scan(/.*\/(.*)\.(\w+).*?$/).flatten
    [(basename.blank? ? 'dummy_filename' : URI.decode(basename)), (ext.blank? ? 'jpg' : ext)]
  end

  private

  def set_dimensions
    return save_image_dimensions if emailed_from.blank?
    file = if Rails.env == 'production'
      File.open(File.join(Rails.root, 'data', File.basename(self.url)))
    else
      mailed_attachment.to_file(:original)
    end
    setup_width_and_height(file)
  end

  def fetch_thumbnail
    case network
    when :twitpic
      self.thumbnail_url = TwitpicParser.get_thumb_image(image_id)
      self.image_url = TwitpicParser.get_image(image_id)
    when :flickr
      self.thumbnail_url = FlickrParser.get_image(image_id, APP_CONFIG['flickr_api_key'])
      self.image_url = self.thumbnail_url
    else
      self.image_url = self.thumbnail_url = url
    end
    if emailed_from.present?
      self.preview = mailed_attachment
    else
      self.preview = Image.fetch_remote_image(thumbnail_url)
    end
  end

  def update_title
    self.page_title = self.description
  end
end
