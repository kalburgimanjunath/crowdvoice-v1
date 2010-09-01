module RackspaceCdnSettings

  def self.included(constant)
    constant.extend ClassMethods
    constant.send(:include, InstanceMethods)
  end

  module ClassMethods

    def rackspace_cdn_settings
      if (Rails.env.production? || Rails.env.staging?)
        { :storage => :rackspace, :cloudfiles_credentials => rackspace_cloudfiles }
      else
        return {}
      end
    end

    def rackspace_cloudfiles
      "#{Rails.root}/config/rackspace_cloudfiles.yml"
    end

  end

  module InstanceMethods
  end

end
