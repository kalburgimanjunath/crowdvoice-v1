require 'spec_helper'

describe NetRequest do

  before :all do
    @invalid_url = 'http://www.fajsflsajflsadkfj.com/'
  end

  should 'validate an url' do
    NetRequest.valid_url?('::').should be_false
  end

  should 'accept a valid url' do
    NetRequest.valid_url?('http://google.com').should be_true
  end

  # What happens if server is not reachable?
  #
  # - DSL client should verify if the url is valid and reachable
  # - if this check passes server should be reachable
  #
  should 'catch an exception and return false if the url is invalid' do
    NetRequest.valid_url?(@invalid_url).should be_false
  end

  # should 'crash' do
  #   NetRequest.get_response(@invalid_url)
  # end

  # What happens if HTML is too big and it times out?

end

