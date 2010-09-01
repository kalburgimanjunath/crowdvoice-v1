require 'spec_helper'

describe YoutubeParser do
  should 'retrieve thumbnail' do
    info = YoutubeParser::Video.fetch_info('yHXwIywGxFs')
    info.image.should == 'http://i.ytimg.com/vi/yHXwIywGxFs/2.jpg'
  end

  should 'retrieve title' do
    info = YoutubeParser::Video.fetch_info('yHXwIywGxFs')
    info.title.should == 'Train FAIL'
  end
end
