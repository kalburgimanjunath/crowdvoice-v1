class TwitpicParser
  
  def self.get_thumb_image(id)
    "http://twitpic.com/show/thumb/#{id}"
  end
  
  def self.get_image(id)
    "http://twitpic.com/show/large/#{id}"
  end
    
end