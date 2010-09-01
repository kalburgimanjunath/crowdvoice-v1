
require 'net/imap'
require 'tmail'
require 'logger'

require File.join(File.dirname(__FILE__), 'imod_plugin')
require File.join(File.dirname(__FILE__), 'net_imap_extension')
require File.join(File.dirname(__FILE__), 'imod_config')
require File.join(File.dirname(__FILE__), 'imod_uid')

# TODO, encapsulate all imod implementation into a Imod module

class Imod

  attr_accessor :search_pattern

  def initialize(config, base)
    @config = config
    @base = base
    safely_create_dir(@config.save_to_folder)
    safely_create_dir(File.dirname(@config.log_file))
    @log = Logger.new(@config.log_file)
    @log.info 'Starting...'
    @imap = Net::IMAP.new(@config.server, @config.port, @config.ssl)
    @search_pattern = ['NOT', 'DELETED']
    @plugins = []
  end

  def add_plugin(constant)
    @plugins << constant
  end

  #
  # - Connect to remote server.
  # - Get a list of emails.
  # - Runs plugins.
  #
  def run_plugins
    authenticate
    @mails = @imap.uid_search(@search_pattern)
    @log.info "Found #{@mails.count} mail(s) in folder #{@config.look_in_folder}"

    objects = @plugins.map do |plugin|
      plugin.new(@imap, @config, @log)
    end

    objects.each { |object| object.post_initialize }

    @mails.each do |uid|
      objects.each { |object| object.parse_mail(uid) }
    end

    objects.each { |object| object.cleanup }

    disconnect
  end

  private

  def disconnect
    @imap.expunge
    @log.info 'Logging out...'
    @imap.logout
  end

  def authenticate
    @log.info "Logging in as #{@config.username} ..."
    @imap.login(@config.username, @config.password)
    @imap.select(@config.look_in_folder)
  end

  def safely_create_dir(name)
    simple = File.join(@base, name)
    return if File.exist?(simple)
    Dir.mkdir(simple)
  end

end

