#require 'sax-machine'
require 'net/http'

module YoutubeParser # :nodoc:
  # Wrapper for thumbnails from a Youtube video
  class Video
    attr_accessor :title, :image
    
    # Returns an array of URL's for the thumbnails of the specified video
    def self.fetch_info(video_id)
      url = "http://gdata.youtube.com/feeds/api/videos/#{video_id}"
      feed = Entry.parse(NetRequest.get(url))
      
      new(feed.title, feed.mediagroup.thumbnails[0])
    end
    
    def initialize(title, image)
      @title = title
      @image = image
    end
  end
end

