class FlickrParser
  
  # Gets an image using the Flickr API
  def self.get_image(id, api_key)
    response = HTTParty.get "http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&photo_id=#{id}&api_key=#{api_key}"
    
    unless response.nil?
      photo = response["rsp"]["photo"]
      
      unless photo.nil?
        farm_id = photo["farm"]
        server_id = photo["server"]
        id = photo["id"]
        secret = photo["secret"]
        
        "http://farm#{farm_id}.static.flickr.com/#{server_id}/#{id}_#{secret}.jpg"
      end
    end
  end
end