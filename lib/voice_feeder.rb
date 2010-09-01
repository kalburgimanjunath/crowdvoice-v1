class VoiceFeeder
  # Gets last url 
  def self.fetch(uri_str)
    NetRequest.get_last_response_with_url(uri_str)[:url]
  end

  def self.fetch_rss( voice, logger = Rails.logger ) 
    # Feed RSS
    logger.info "Original RSS: #{voice.rss_feed}"
    
    begin
      real_rss = fetch(voice.rss_feed)
      logger.info "Real RSS: #{real_rss}"
      feed = REXML::Document.new(open(real_rss))
    rescue
      logger.error "Error while fetching the RSS: #{voice.rss_feed}"
      return 
    end
  
    rss_errors = 0
    added_rss_links = 0
    last_rss = nil
    feed.elements.each('rss/channel/item') do |node|
      link = node.get_elements('link').first
      
      dateElement = node.get_elements('pubDate').first
      if dateElement.nil? 
        dateElement = feed.get_elements('rss/channel/pubDate').first
      end
      pubDate = DateTime.parse(dateElement.text)

      last_rss = pubDate unless not last_rss.nil? and (last_rss <=> pubDate) >= 0 

      # compare dates
      if not voice.last_rss.nil? and (voice.last_rss <=> pubDate) >= 0
        logger.info "Reached last RSS! stoping..."
        break
      end

      begin
        url = fetch(link.text)
      rescue
        logger.error " Error fetching #{link.text}"
      end

      content = voice.build_content_from_url(url) unless url.nil?
      unless content.nil?
        (rss_errors += 1 and next) unless content.valid?
        added_rss_links += 1
        content.save(:run_callbacks => false)
      else
        rss_errors += 1
      end
    end

    # save pubDate of the last RSS
    unless not voice.last_rss.nil? and (voice.last_rss <=> last_rss) >= 0
      voice.last_rss = last_rss
      voice.save
    end

    logger.info "  Added #{added_rss_links} links."
    logger.error "  #{rss_errors} invalid urls within the RSS..." if rss_errors > 0
  end

  def self.fetch_tweets( voice, logger = Rails.logger )
    # Feed with twitter links
    twitter_results = Twitter::Search.new( voice.twitter_search ).fetch().results
    tweet_errors = 0
    added_tweet_links = 0
    last_tweet = nil
    twitter_results.each do |tweet|
      pubDate = DateTime.parse(tweet.created_at)
      last_tweet = pubDate unless not last_tweet.nil? and (last_tweet <=> pubDate) > 0

      # compare dates
      if not voice.last_tweet.nil? and (voice.last_tweet <=> pubDate) >= 0
        logger.info "Reached last Tweet! stoping..."
        break
      end

      tweet.text.scan( /https?:\/\/[^ ]+/ ).each do |link|
        begin
          url = fetch(link)
        rescue
          logger.error " Error fetching #{link}"
        end

        content = voice.build_content_from_url(url) unless url.nil?
        unless content.nil?
          (tweet_errors += 1 and next) unless content.valid?
          added_tweet_links += 1
          begin
          content.save
          rescue
          end
        end
      end 
      
    end

    # save pubDate of the last tweet
    unless not voice.last_tweet.nil? and (voice.last_tweet <=> last_tweet) >= 0
      voice.last_tweet = last_tweet
      voice.save
    end
    
    logger.info "  Added #{added_tweet_links} links."
    logger.error "  #{tweet_errors} invalid urls within the tweet search..." if tweet_errors > 0
  end

  def self.feed_voice(voice, logger = Rails.logger)
    logger.info "Fetching voice: #{voice.title}"

    unless voice.rss_feed.blank?
      fetch_rss(voice, logger) 
    else
      logger.info "Rss empty."
    end

    unless voice.twitter_search.blank?
      fetch_tweets(voice, logger) 
    else
      logger.info "Twitter search empty (shouldn't be)."
    end
  end

end
