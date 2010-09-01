require 'spec_helper'

describe Link do

  before(:each) do
    @link = Factory.build :link
  end

  should 'be an instance of link' do
    @link.should be_instance_of Link
  end

  context 'fetch title and image' do

    before (:each) do
      @link.url = 'http://teletekst.een.be/tt_een.php'
      @link.save
    end

    should 'fetch a title' do
      fail 'Title is wrong' unless @link.page_title =~ /teletekst/
    end

    # Image fetching spec
    #
    # TODO: actually fetch first image. Show a carousel of available
    # images if more than one seems to be suitable.
    #
    should 'fetch an image' do
      @link.thumbnail_url.should_not == nil
    end

  end

  should 'properly get response of non-standard subdomains' do
    lambda do
      @link.url = 'http://hugo_villegas.blogspot.com/2006/08/protestas-por-plutn.html'
      @link.save!
    end.should_not raise_error
  end

end
