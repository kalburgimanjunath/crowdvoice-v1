require 'spec_helper'

describe Video do

  before(:each) do
    @video = Factory.build :video
  end

  should 'be an instance of Video' do
    @video.should be_instance_of Video
  end

  should 'detect if the url is from youtube' do
    @video.url = 'http://www.youtube.com/watch?v=ginTCwWfGNY'
    @video.network.should == :youtube
  end

  should 'detect if the url is from vimeo' do
    @video.url = 'http://vimeo.com/11229946'
    @video.network.should == :vimeo
  end

  describe 'video_id from youtube' do
    should 'get the video id correctly' do
      @video.url = 'http://www.youtube.com/watch?v=ginTCwWfGNY'
      @video.video_id.should == 'ginTCwWfGNY'
    end
  end

  describe 'video_id from vimeo' do

    should 'get the video id correctly' do
      @video.url = 'http://vimeo.com/11229946'
      @video.video_id.should == '11229946'
    end

    context 'when HD enabled' do

      should 'get the video id correctly' do
        @video.url = 'http://vimeo.com/hd#11229946'
        @video.video_id.should == '11229946'
      end

    end
  end

  context 'fetch thumbnail from vimeo' do

    before(:each) do
      @video = Factory :vimeo
    end

    should 'fetch thumbnail' do
      @video.thumbnail_url.should == 'http://b.vimeocdn.com/ts/611/339/61133956_200.jpg'
    end
  end

  context 'fetch thumbnail from youtube' do

    before(:each) do
      @video = Factory :youtube
    end

    should 'fetch thumbnail' do
      @video.thumbnail_url.should == 'http://i.ytimg.com/vi/ginTCwWfGNY/2.jpg'
    end
  end
end
