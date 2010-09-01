require 'spec_helper'

describe FlickrParser do

  should 'retrieve image' do
    p = FlickrParser.get_image('4573415123', '32368fc1cf1f34fc900adfc83a60f644')
    p == 'http://farm5.static.flickr.com/4004/4573415123_0c092eb69c.jpg'
  end

end
