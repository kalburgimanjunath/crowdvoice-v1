class ImodPlugin

  class Error < Exception

    def self.method_missing(name)
      raise new("The method ('#{name}') needs to be implemented in your plugin class")
    end

  end

  def initialize(imap, config, log)
    @imap, @config, @log = imap, config, log
  end

  def post_initialize
    Error.method_missing('post_initialize')
  end

  def parse_mail(uid)
    Error.method_missing('parse_mail')
  end

  def cleanup
    Error.method_missing('cleanup')
  end

end
