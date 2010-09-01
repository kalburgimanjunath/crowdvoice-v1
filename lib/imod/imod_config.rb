
class ImodConfig

  VALID_ATTRIBUTES = [
    :username, :password, :look_in_folder,
    :downloaded_mails_folder, :save_to_folder,
    :oversized_mails_folder, :server, :port, :ssl, :log_file,
    :max_mail_size
  ]

  attr_accessor *VALID_ATTRIBUTES

  class Error < Exception

    def self.invalid_config
      new('Invalid configuration!')
    end

  end

  def initialize(hash)
    if simplify(hash.keys) != simplify(VALID_ATTRIBUTES)
      raise Error.invalid_config
    end
    VALID_ATTRIBUTES.each do |key|
      instance_variable_set("@#{key}", hash[key.to_s])
    end
  end

  private

  def simplify(array)
    array.map { |x| x.to_s }.sort
  end

end

