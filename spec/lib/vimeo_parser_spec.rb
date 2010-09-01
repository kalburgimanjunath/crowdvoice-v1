require 'spec_helper'

describe VimeoParser do
  should 'retrieve thumbnail' do
    info = VimeoParser::Video.fetch_info('11229946')
    info.image.should == 'http://b.vimeocdn.com/ts/611/339/61133956_200.jpg'
  end

  should 'retrieve title' do
    info = VimeoParser::Video.fetch_info('11229946')
    info.title.should == 'Lights Out'
  end
end
