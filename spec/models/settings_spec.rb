require 'spec_helper'

describe Settings do
  should 'create a setting if not present' do
    lambda { Settings.a }.should raise_error
    Settings.a = 1
    Settings.a.should == 1
  end
end
