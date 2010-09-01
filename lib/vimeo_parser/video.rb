# TODO: check vimeo gem out:
#
#
# Github
# - http://github.com/matthooks/vimeo
#
# API
# - Vimeo::Simple::Video.info("video_id")
#
module VimeoParser # :nodoc:
  # Wrapper for thumbnails from a Vimeo video
  class Video
    attr_accessor :title, :image

    # Returns a URL for the thumbnail of the specified video
    def self.fetch_info(video_id)
      response = HTTParty.get "http://vimeo.com/api/v2/video/#{video_id}.json"
      new(response[0]["title"], response[0]["thumbnail_medium"])
    end

    def initialize(title, image)
      @title = title
      @image = image
    end
  end
end
