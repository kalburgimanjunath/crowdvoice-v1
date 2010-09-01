require 'spec_helper'

describe TwitpicParser do
  should 'retrieve image' do
    p = TwitpicParser.get_image('http://twitpic.com/1mz3kn')

    p == 'http://web6.twitpic.com/img/99055319-0a8851159a3e18d1cec8eff2ef833a0f.4be99fb6-full.png'
  end
end
