require 'spec_helper'

describe Voice do

  before(:each) do
    @voice = Factory.build :voice
  end

  should 'be valid' do
    @voice.should be_valid
  end

  should 'require a location' do
    @voice.location = ''
    @voice.should_not be_valid
  end

  should 'not require a twitter search' do
    @voice.twitter_search = ''
    @voice.should be_valid
  end

  describe 'mode' do

    should 'be *Go* if submissions are allowed' do
      @voice.allow_posting?.should be_true
      @voice.mode.should == 'Go'
    end

    should 'be *Stop* if no submissions are allowed' do
      @voice.allow_posting = false
      @voice.mode.should == 'Stop'
    end

  end

  describe 'title' do

    should 'have a unique title' do
      Factory :voice, :title => 'Foo Bar'
      @voice.title = 'foo bar'
      @voice.should_not be_valid
    end

    should 'have a non-blank title' do
      @voice.title = nil
      @voice.should_not be_valid
    end

  end

  should 'be created by a user' do
    @voice.user = nil
    @voice.should_not be_valid
  end

  describe 'background images' do
    should 'have a background image' do
      @voice.background_image = nil
      @voice.should_not be_valid
    end

    should 'have a header background image' do
      @voice.header_background_image = nil
      @voice.should_not be_valid
    end
  end

  should 'have a color' do
    @voice.color.should_not == nil
  end

  describe 'slug' do
    should 'have slug' do
      @voice.slug.should_not == ''
    end

    should 'have a valid slug' do
      @voice = Factory :voice, :title => 'This is my_title %with spéciäl characters-<>-!2'
      @voice.save
      @voice.slug.should == 'this-is-my-title-with-special-characters--2'
    end
  end

  describe 'automatic feed' do
    should 'add rss content after save' do
      @voice.rss_feed = nil
      @voice.contents = []
      @voice.save
      @voice.rss_feed = "http://news.google.com/news?pz=1&cf=all&ned=es_mx&hl=es&output=rss"
      @voice.save
      @voice.reload
      @voice.contents.should_not be_empty
    end

    should 'add twitter links after save' do
      @voice.twitter_search = nil
      @voice.save
      @voice.twitter_search = "#google"
      @voice.contents = []
      @voice.save
      @voice.reload
      @voice.contents.should_not be_empty
    end
  end 

end
