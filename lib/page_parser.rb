
# HTML page parser
#
# Downloads a remote HTML document identified by an URL
# and retrives its contents
#
#   - Images
#   - Title
#   - Body
#
# TODO: Implement an Error class
#
class PageParser

  class Error < Exception; end
  class << Error; end

  # Default image for document
  #
  # If The parser can't find an image in the page this image will be
  # used instead
  #
  # TODO: Abstract this logic away from this class
  #
  DEFAULT_IMAGE = 'http://c1736512.cdn.cloudfiles.rackspacecloud.com/link-default.png'

  # Default title
  #
  DEFAULT_TITLE = '(no title)'

  # Default body
  #
  DEFAULT_BODY = '(no text)'

  # Client headers for remote server
  #
  # The headers specified here will be sent to remote servers when a
  # request is made.
  REQUEST_HEADERS = {
    'User-Agent' => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_3; en-us) AppleWebKit/531.22.7 (KHTML, like Gecko) Version/4.0.5 Safari/531.22.7'
    # 'Accept' => '*/*',
    # 'Connection' => 'keep-alive',
    # 'Referer' => 'http://crowdvoice.org',
    # 'Host' => '',
    # 'Accept-Language' => 'en-us',
    # 'Accept-Encoding' => 'gzip,deflate',
    # 'Accept-Charset' => 'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
    # 'Content-Length' => '0'
  }
  
  # HTML title getter
  #
  def title
    @title ||= extract_title
  end

  def extract_title
    if doc.at_css('title')
      return doc.at_css('title').content.strip
    end
    DEFAULT_TITLE
  end

  # Gets the description of the page.
  #
  # It tries to find the meta-tag +description+ first,
  # then it tries with the tag +article+, then the <tt>#content</tt> selector
  # and finally the body itself if no one was found.
  #
  def description
    @description ||= extract_description
  end

  # Meta-tag analizer
  #
  def meta(type = 'description')
    doc.at_css("meta[@name='#{type}']")
  end

  # Verfifies if meta is present
  def has_meta?(type = 'description')
     meta(type) ? true : false
  end

  def has_content?
    content ? true : false
  end

  # Description extractor
  #
  # Gets the description from the document
  #
  # TODO: catch an exception and return a default value if something
  # is thrown.
  #
  def extract_description
    return meta['content'] if has_meta?
    return DEFAULT_BODY unless has_content?
    return DEFAULT_BODY if content.text == ''
    format_text(content.text)
  end

  # First Image
  #
  # Convinience method for retriving the first Image inthe document.
  #
  def first_image
    images.first
  end

  # Class method to initialize the instance
  def self.parse(url, dok = nil)
    url = "http://#{url}" unless /http:\/\/.*/ =~ url

    if dok.nil?
      dok = Nokogiri::HTML(NetRequest.get(url, REQUEST_HEADERS))
    else
      dok = Nokogiri::HTML(dok)
    end
      
    new(url, dok)
  end

  # TODO: uncomment visibility
  # protected

  # Readers
  #
  attr_reader :doc, :url, :url_host

  # Document images retriver
  #
  # Gets the images of the page
  # It tries with the +link+ tag that facebook uses on their link share.
  #
  # If no fb tag is present, then it fetchs all the images in the document.
  #
  def images
    @images ||=
    begin
      fb_tag = doc.at_css("link[@rel='image_src']")
      if fb_tag
        [expand_relative_path(fb_tag['href']) || DEFAULT_IMAGE]
      else
        images = doc.search('img').map do |img|
          expand_relative_path(img.attribute('src').content) unless img.attribute('src').nil?
        end
        images.empty? ? images << DEFAULT_IMAGE : images
      end
    end
  end

  # Image availability checker
  #
  #  ==== Returns
  #
  #  - boolean
  #
  def images?
    images != []
  end

  # Url full path generator
  #
  # Adds the root of the url if the path relative
  #
  def expand_relative_path(path)
    path.strip!
    return path if path =~ /^https?:\/\//
    URI.join("http://#{@url_host}", URI.encode(path)).to_s
  end

  # HTML document text scanner
  #
  # Looks for various tags and fetches text from its contents
  #
  def content
    @content ||= case
    when doc.at_css('article')
      doc.at_css('article')
    when doc.at_css('#content')
      doc.at_css('#content')
    when doc.at_css('p')
      doc.at_css('p')
    when doc.at_css('li')
      doc.at_css('li')
    when doc.at_css('strong')
      doc.at_css('strong')
    else
      doc.at_css('div')
    end
  end

  # Text formatter
  #
  # TODO: Hmm... May be move this to a String class?
  #
  def format_text(string)
    string.gsub!(/[\t\n]+/i, ' ')
    string.gsub!(/\s{2,}/, ' ')
    ApplicationController.helpers.truncate string.strip, :length => 150
  end

  # Protected initializer
  #
  def initialize(url, dok)
    @url = URI(url)
    @doc = dok
    @url_host = @url.host
  end

end
