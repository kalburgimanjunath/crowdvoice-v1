require 'spec_helper'

describe Vote do

  before(:each) do
    @vote = Factory.build :vote
  end

  def hash
    @hash ||= MD5.hexdigest("#{Time.now.tv_sec}")
  end

  should 'have a unique ip_address' do
    link = Factory.build :link,
      :url => "http://#{hash}.com",
      :thumbnail_url => "http://#{hash}.com/thumbnail_url.jpg",
      :page_title => "title: #{hash}"
    Factory :vote, :ip_address => '127.0.0.1', :content => link
    @vote.ip_address = '127.0.0.1'
    @vote.content = link

    @vote.should_not be_valid
  end

  should 'have a content of any content type' do
    image = Factory :image
    @vote.content = image
    @vote.save
    @vote.content.should == image
  end


  context 'update counters' do

    should 'update positive vote counter' do
      @vote.rating = 1
      @vote.save
      @vote.content.reload.positive_votes_count.should == 1
    end

    should 'update negative vote counter' do
      @vote.rating = -1
      @vote.save
      @vote.content.reload.negative_votes_count.should == 1
    end

    should 'update overall score counter' do
      @vote.rating = -1
      @vote.save
      @vote.content.reload.overall_score.should == -1
    end
  end
end
