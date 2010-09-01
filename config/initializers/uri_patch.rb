# Allow non-standard subdomains, like somethig_with_underscore.domain.com
module URI # :nodoc:
  module REGEXP
    module PATTERN
      # While this regexp for hostname is exactly what is in RFC 2396, it fails to
      # account for a necessary use case mentioned in the text of the RFC, 
      # section 3.2.2. - "In practice, however, the host component may be a local
      # domain literal
      # HOSTNAME = "(?:#{DOMLABEL}\\.)*#{TOPLABEL}\\.?"
      remove_const :HOSTNAME
      HOSTNAME = "(?:#{DOMLABEL}\\.)*#{TOPLABEL}\\.?|(?:#{DOMLABEL}?)"
    end
  end
  
  class Generic
    def self.use_registry
      true
    end
  end
end
