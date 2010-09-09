require 'spec_helper'
require 'md5'

describe Content do

  def hash
    @hash ||= MD5.hexdigest("#{Time.now.tv_sec}")
  end

  before(:each) do
    @content = Factory.build :link,
      :url => "http://#{hash}.com",
      :thumbnail_url => "http://#{hash}.com/thumbnail_url.jpg",
      :page_title => "title: #{hash}"
  end

  after :each do
    Content.all.map &:destroy
  end

  should 'be valid' do
    @content = Factory.build :link
    @content.should be_valid
  end

  describe 'being created from URL' do
    should 'have the url set to the passed URL' do
      url = 'http://www.milenio.com/node/515827'
      @content = Content.build_from_url(url)
      @content.url.should == url
    end

    context 'for Video' do
      should 'create an instance of Video from a YouTube url' do
        @content = Content.build_from_url('http://www.youtube.com/watch?v=ginTCwWfGNY')
        @content.video?.should be_true
      end

      should 'create an instance of Video from a Vimeo url' do
        @content = Content.build_from_url('http://vimeo.com/11229946')
        @content.video?.should be_true
      end
    end

    context 'Image' do
      should 'create an instance of Image from a Flickr url' do
        @content = Content.build_from_url('http://www.flickr.com/photos/edgarjs/4573415123/')
        @content.image?.should be_true
      end

      should 'create an instance of Image from a Twitpic url' do
        @content = Content.build_from_url('http://twitpic.com/1ms2bc')
        @content.image?.should be_true
      end

      should 'create an instance of Image from a direct URL to an image file' do
        @content = Content.build_from_url('http://farm5.static.flickr.com/4049/4547496837_8ae7d82093_b.jpg')
        @content.image?.should be_true
      end
    end

    context 'Link' do
      should 'create an instance of Link from an undetected URL' do
        @content = Content.build_from_url('http://www.apple.com')
        @content.link?.should be_true
      end
    end
  end

  describe 'url' do

    def invalid_urls
      [
        'algo.com',
        'htt://asdasd.com',
        'http:// badurl.com',
        'http://badurl',
        'http://example url.com.mx',
        'http:/badurl.mx'
      ]
    end

    should 'be required' do
      @content.url = nil
      @content.should_not be_valid
    end

    should 'validate presence of url even if emailed_from is set' do
      @content.emailed_from = 'crowdvoice@example.com'
      @content.url = nil
      @content.should_not be_valid
    end

    should 'have a valid format' do
      invalid_urls.each do |url|
        @content.url = url
        @content.should_not be_valid
      end
    end

  end

  context 'beign created' do

    should 'not be approved' do
      @content.approved.should be_false
    end

    should 'have 0 negative and positive votes count' do
      @content.negative_votes_count.should == 0
      @content.positive_votes_count.should == 0
    end

  end

  should 'have a unique URL within the same voice' do
    url = "http://freshout.us"
    voice = Factory :voice
    Factory :link, :url => url, :voice => voice

    @content = Factory.build :link, :url => url, :voice => voice
    @content.should_not be_valid

    @content = Factory.build :link, :url => url, :voice => Factory(:voice)
    @content.should be_valid
  end

end
