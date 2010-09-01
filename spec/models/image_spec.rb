require 'spec_helper'

describe Image do

  before(:each) do
    @image = Factory.build :image
  end

  should 'save width and height of the remote image url' do
    @image.save
    @image.width.should == 1024
    @image.height.should == 768
  end

end
