class TwitterController < ApplicationController
  before_filter :find_client
  before_filter :find_voice
  
  # Called when the user clicks on the retweet link
  def retweet
    session[:twitter_token] = @client.request_token\
      :oauth_callback => retweet_callback_voice_url(@voice, params[:tweet_id])
      
    if @client.authorized?
      @client.retweet(params[:tweet_id])
      redirect_to @voice
    else
      redirect_to session[:twitter_token].authorize_url
    end
  end
  # Called when the user clicks on the Spread => Twitter icon
  def twitter_share
    session[:twitter_token] = @client.request_token\
      :oauth_callback => twitter_share_callback_voice_url(@voice)
      
    if @client.authorized?
      update_msg = @voice.tweet_message(shorten_url voice_url(@voice))
      @client.update(update_msg)
      redirect_to @voice
    else
      redirect_to session[:twitter_token].authorize_url
    end
  end
  
  # Called after Twitter has finished authorization
  def twitter_share_callback
    update_msg = @voice.tweet_message(shorten_url voice_url(@voice))
    if handle_twitter_callback(:update, update_msg)
      flash[:notice] = "Tweet succesfully posted."
    else
      flash[:alert] = "Tweeting Failed!"
    end
    redirect_to @voice
  end
  
  # Called after Twitter has finished authorization
  def retweet_callback
    if handle_twitter_callback(:retweet, params[:tweet_id])
      flash[:notice] = "Tweet succesfully retweeted"
    else
      flash[:alert] = "Retweeting Failed!"
    end
    redirect_to @voice
  end
  
  private
  
  # Handles twitter callback for :retweet and :update
  def handle_twitter_callback(*args)
    request_token = session[:twitter_token]
    session[:twitter_token] = nil
    access_token = @client.authorize(
      request_token.token,
      request_token.secret,
      :oauth_verifier => params[:oauth_verifier]
    ) rescue nil
    if @client.authorized?
      session[:twitter_access_token] = access_token.token
      session[:twitter_access_secret] = access_token.secret
      @client.send(args.shift, *args)
    end
  end
  
  def find_client
    unless session[:twitter_access_token].nil? && session[:twitter_access_secret].nil?
      @client = TwitterOAuth::Client.new(
        :consumer_key => APP_CONFIG['twitter_consumer_key'],
        :consumer_secret => APP_CONFIG['twitter_consumer_secret'],
        :token => session[:twitter_access_token],
        :secret => session[:twitter_access_secret]
      )
    else
      @client = TwitterOAuth::Client.new(
        :consumer_key => APP_CONFIG['twitter_consumer_key'],
        :consumer_secret => APP_CONFIG['twitter_consumer_secret']
      )
    end
  end
  
  def find_voice
    @voice = Voice.find_by_slug(params[:id])
  end
end
