require 'spec_helper'

describe User do

  before(:each) do
    @user = Factory.build :user
  end

  should 'be valid' do
    @user.should be_valid
  end

  describe 'email' do

    should 'not be valid if the there is other user with the same email' do
      Factory :user, :email => 'foo@bar.com'
      @user.email = 'foo@bar.com'
      @user.should_not be_valid
    end

    should 'not be valid if @ character is not present' do
      @user.email = 'foobar.com'
      @user.should_not be_valid
    end

    should 'not be valid if the domain is incomplete' do
      @user.email = 'foo@bar'
      @user.should_not be_valid
    end

    should 'not be valid if the name is incomplete' do
      @user.email = '@bar.com'
      @user.should_not be_valid
    end

    should 'not be valid if contains special characters' do
      @user.email = 'foo!!!@bar.com'
      @user.should_not be_valid
    end

  end

  describe 'role' do

    should 'not be blank' do
      @user.role = nil
      @user.should_not be_valid
    end

    should 'be one of (admin | moderator)' do
      @user.role = 'foobar'
      @user.should_not be_valid
    end

    should 'be moderator by default' do
      @user.moderator?.should be_true
    end
  end
end
