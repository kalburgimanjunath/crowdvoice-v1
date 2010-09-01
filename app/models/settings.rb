require 'ostruct'
class Settings < ActiveRecord::Base
  serialize :settings_hash
  attr_protected :settings_hash

  # Each iterator delegator to settings_hash
  def self.each(&block)
    settings.settings_hash.each(&block)
  end

  # Getter for settings
  # ==== Example
  # Settings[:example] # => "this is an example"
  def self.[](key)
    settings.settings_hash[key]
  end

  # Setter for settings
  # ==== Example
  # Settings[:example] = "This is a setter"
  def self.[]=(key, value)
    s = settings
    s.settings_hash[key] = value
    s.save
  end

  # Shortcut for getter. Call it as an attribute
  #
  # However this will raise a method missing error if settings
  # doesn't have the property yet.
  # ==== Example
  # Settings.example # => "this is an example"
  def self.method_missing(method_name, *args)
    init_default_settings(:approved_threshold => 1, :posts_per_page => 10)
    s = settings
    if s.settings_hash && s.settings_hash.has_key?(method_name)
      self[method_name]
    elsif s.settings_hash && method_name.id2name =~ /(\w+)=$/
      self[$1.to_sym] = args.shift
    else
      super
    end
  end

  private
  
  # Sets the default settings values in case they're not present
  def self.init_default_settings(default_settings)
    s = settings
    default_settings.each do |k, v|
      self[k.to_sym] = v unless s.settings_hash.has_key?(k.to_sym)
    end
  end

  # Finds first row of settings.
  def self.settings
    if table_exists?
      f = first
      unless f
        f = new
        f.settings_hash = {}
        f.save!
      end
      f
    else
      ::OpenStruct.new(:settings_hash => {})
    end
  end
end
