namespace :voices do
  desc 'Feeds the voice with new content'
  task :feed => :environment do 
    # Logger
    logger = Logger.new("#{Rails.root}/log/feed.log")
    
    # Fetch all voices
    logger.info "\nStarting to fetch all voices (#{Time.now})..."
    if ENV['VOICE_ID'].blank?
      voices = Voice.all
    else
      voices = [Voice.find_by_id(ENV['VOICE_ID'])]
    end
    voices.each do |voice|
      VoiceFeeder.feed_voice(voice, logger)
    end 

    logger.info "Finished Fetching RSS feeds..."
  end
end
