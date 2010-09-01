require 'spec_helper'

describe Announcement do
  before(:each) do
    @announcement = Factory.build :announcement
  end

  should 'be valid' do
    @announcement.should be_valid
  end

  context 'title' do

    should 'not be blank' do
      @announcement.title = nil
      @announcement.should_not be_valid
    end

  end

  should 'not be blank' do
    @announcement.content = nil
    @announcement.should_not be_valid
  end

  should 'belong to a voice' do
    @announcement.voice = nil
    @announcement.should_not be_valid
  end
end
