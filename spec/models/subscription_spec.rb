require 'spec_helper'

describe Subscription do
  before(:each) do
    @subscription = Factory.build :subscription
  end

  should 'have a voice' do
    @subscription.voice = Factory :voice
    @subscription.save
    @subscription.voice.should_not == nil
  end

  should 'have a unique email address' do
    voice = Factory :voice
    Factory :subscription, :email => 'user@host.com', :voice => voice
    @subscription.voice = voice
    @subscription.should_not be_valid
  end

  should 'generate a hashed email when created' do
    @subscription.save!
    @subscription.email_hash.should_not be_blank
  end

end
