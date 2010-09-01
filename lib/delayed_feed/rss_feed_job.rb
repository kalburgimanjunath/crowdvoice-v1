module DelayedFeed 
  class RssFeedJob < Struct.new(:voice_id)
    def perform
      system "cd #{Rails.root} && RAILS_ENV=#{Rails.env} rake voices:feed VOICE_ID=#{voice_id}"
    end    
  end
end
