require 'spec_helper'

describe StaticPage do

  before(:each) do
    @static_page = Factory.build :static_page
  end

  should 'be have a unique type' do
    Factory :static_page, :page_type => 'atype'
    @static_page.page_type = 'atype'
    @static_page.should_not be_valid
  end

  should 'have a title' do
    @static_page.title = ''
    @static_page.should_not be_valid
  end

  should 'have content' do
    @static_page.content = ''
    @static_page.should_not be_valid
  end
end
