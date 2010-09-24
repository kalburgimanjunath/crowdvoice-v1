# -*- coding: utf-8 -*-
# FIXME: Why do I need to require paperclip? http://j.mp/a9DkY3
require 'paperclip'

class Voice < ActiveRecord::Base

  belongs_to :user
  has_many :contents, :dependent => :destroy, :order => "created_at DESC, overall_score DESC"
  has_many :videos, :dependent => :destroy, :order => "created_at DESC, overall_score DESC"
  has_many :images, :dependent => :destroy, :order => "created_at DESC, overall_score DESC"
  has_many :links, :dependent => :destroy, :order => "created_at DESC, overall_score DESC"
  has_many :subscriptions, :dependent => :destroy
  has_many :announcements, :dependent => :destroy

  include RackspaceCdnSettings

  has_attached_file :background_image, ({
    :styles => {
      :large => "800x594>", :small => "70x62#", :thumb_wdgt => "61x67#"
    },
    :processors => [:cropper]
  }).merge(rackspace_cdn_settings)

  has_attached_file :header_background_image, rackspace_cdn_settings

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  before_save :generate_slug
  before_save :reset_feed_timestamps
  after_save :save_background_geometry
  after_save :add_content
  after_update :reprocess_background_image, :if => :cropping?

  validates :user_id,
    :presence => true

  validates :title,
    :presence => true,
    :uniqueness => { :case_sensitive => false }

  validates :location,
    :presence => true

  validates :fb_page_url, :url => { :allow_blank => true }
  
  validates :map_url, :url => { :allow_blank => true }

  validates :latitude, :numericality => { :allow_blank => true }
  validates :longitude, :numericality => { :allow_blank => true }

  validates_attachment_presence :background_image
  validates_attachment_size :background_image, :less_than => 2.megabytes
  validates_attachment_content_type :background_image, :content_type => ['image/jpeg', 'image/jpg', 'image/x-jpeg', 'image/x-jpg', 'image/pjpeg', 'image/png', 'image/x-png']

  validates_attachment_presence :header_background_image
  validates_attachment_size :header_background_image, :less_than => 2.megabytes
  validates_attachment_content_type :header_background_image, :content_type => ['image/jpeg', 'image/jpg', 'image/x-jpeg', 'image/x-jpg', 'image/pjpeg', 'image/png', 'image/x-png']

  # Parses facebook page id from facebook page url
  def fb_page_id
    fb_page_url.scan(/^http:\/\/(?:www\.)?facebook.com\/(?:(?:pages\/[^\/]+\/(\d+))|(?:([^\/]+)))$/i).to_s if fb_page_url.present?
  end

  # Reset last timestamp of the RSS and twitter inclusion
  def reset_feed_timestamps
    if self.rss_feed_changed?
      self.last_rss = nil
    end
    if self.twitter_search_changed?
      self.last_tweet = nil
    end
  end
  
  # Adds new content based on rss_feed and twitter_search
  def add_content
    if self.rss_feed_changed? and not self.rss_feed.blank?
      unless Rails.env.test? 
        Delayed::Job.enqueue DelayedFeed::RssFeedJob.new(self.id)
      else
        self.changed_attributes.delete("rss_feed")
        VoiceFeeder.fetch_rss(self)
      end
    end

    if self.twitter_search_changed? and not self.twitter_search.blank?
      unless Rails.env.test?
        Delayed::Job.enqueue DelayedFeed::RssFeedJob.new(self.id)
      else
        self.changed_attributes.delete("twitter_search")
        VoiceFeeder.fetch_tweets(self)
      end
    end
  end

  scope :visible, where(:show_in_homepage => true).order("updated_at desc").limit(5)

  # Results per page
  def self.per_page
    @per_page ||= 10
  end

  # Builds the update message for twitter
  def tweet_message(url)
    msg = ApplicationController.helpers.truncate(title, :length => 100)
    CGI.unescape "#{msg} - #{url}"
  end

  # Fetchs the url to detect content type and builds an instance.
  def build_content_from_url(url, attrs = {})
    Content.build_from_url(url, attrs).tap do |content|
      content.voice = self if content
    end
  end

  # Displays mode based on allow_posting attribute
  def mode
    allow_posting? ? 'Go' : 'Stop'
  end

  # Returns the location map URL
  def location_url
    map_url.present? ? map_url : "http://maps.google.com/?q=#{CGI::escape location}"
  end

  # Checks if we are cropping the background image
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  # Returns width and height of the background image
  def background_image_geometry(style = :original)
    @geometry ||= {}
    if Rails.env.production?
      tmp_file = Tempfile.new("tmp_geometry")
      background_image.to_file(style).save_to_filename(tmp_file.path)
      @geometry[style] ||= Paperclip::Geometry.from_file(tmp_file)
    else
      @geometry[style] ||= Paperclip::Geometry.from_file(background_image.path(style))
    end

    @geometry[style]
  end

  # Override id
  def to_param
    self.slug
  end
  
  private

  # CloudFiles::StorageObject
  # extract contents from a storage object so ImageMagick can process it.
  def generate_an_identifiable(file)
    temp = Tempfile.new('file.jpg')
    temp.write(file.data)
    temp.close
    temp
  end

  # Find out if we have a File, or a CloudFiles::Object
  # and return the correct object for ImageMagick
  def resolve_accessable_background_stream
    file = background_image.to_file(:original)
    return file unless file.respond_to? :data
    generate_an_identifiable(file)
  end

  def save_background_geometry
    dimensions = Image.dimensions(resolve_accessable_background_stream)
    unless background_image_width == dimensions[:width] && background_image_height == dimensions[:height]
      self.update_attributes(:background_image_width => dimensions[:width], :background_image_height => dimensions[:height])
    end
  end

  # FIXME: Is throwing an error when croping
  def reprocess_background_image
    background_image.reprocess!
  end

  # Escapes title of voice to generate a friendly slug for urls
  def generate_slug
    str = self.title.downcase.strip

    str.gsub!(/[\s_]/, '-')
    str.gsub!(/[áä]/, 'a')
    str.gsub!(/[éë]/, 'e')
    str.gsub!(/[îï]/, 'i')
    str.gsub!(/[óö]/, 'o')
    str.gsub!(/[úü]/, 'u')
    str.gsub!(/ç/, 'c')
    str.gsub!(/œ/, 'ae')
    str.gsub!(/ñ/, 'n')
    str.gsub!(/[^\w-]/, '')

    self.slug = str
  end

  # Mail recipient validator
  #
  # Checks if a mail_recipient is valid.
  #
  # - must return false if mail_recipient is not a string
  # - must return false if mail_recipient does not have a plus sign
  # - must return false if mail_recipient does not have an at sign
  # - must return false if extracted Voice.id does not exist in db.
  #
  #  ==== Returns
  #  - boolean
  #
  def self.valid_mailbox?(mail_recipient)
    return false unless mail_recipient.looks_like_voice_mail?
    exists?(mail_recipient.extract_voice_id)
  end

  def self.find_by_target_recipient(mail_recipient)
    return nil unless mail_recipient.looks_like_voice_mail?
    find(mail_recipient.extract_voice_id)
  end

  
end
