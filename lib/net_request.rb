
# Wrapper class for Net::HTTP
#
# Handles non-standard subdomains such as:
#
#   - something_underscored.domain.com
#
# and simplifies response obtain for http requests.
#
class NetRequest; end

class << NetRequest

  TIMEOUT = 10

  # Gets a raw HTTPResponse object
  #
  # NOTE: call the *valid_url?* method before calling this to make
  # sure that a connection can be established.
  #
  #  ==== Returns
  #
  #  - HTTPResponse if connection to the server was successful.
  #  - SocketError, .. if something when wrong!
  #
  def get_response(url, headers = {}, retries = 3)
    extract_http_response_object(url, headers, retries)
  end

  # Gets a raw HTTPResponse object
  #
  # Same as the *get_response* method but this one will not raise an
  # exception if something goes wrong with the connection
  #
  #  ==== Returns
  #
  #  - HTTPResponse if connection to the server was successful.
  #  - nil if there was an error with the connection
  #
  def get_safe_response(url, headers = {}, retries = 3)
    begin
      extract_http_response_object(url, headers, retries)
    rescue SocketError, Timeout::Error, ArgumentError
      nil
    end
  end

  # Returns the entity  body.
  #
  # Calling this method a second or subsequent time will return the
  # already read string.
  #
  #  ==== Returns
  #
  #  - string if connection to the server was successful.
  #
  #  - nil otherwise
  #
  # NOTE: use the *valid_url?* method before you call this method.
  #
  def get(url, headers = {})
    return nil unless valid_url? url
    response = get_response(url, headers)
    response.body if response
  end

  # HTTP URL validator
  #
  # Tells whether or not the url can be parsed and reached.
  #
  # What happens if server is not reachable?
  #
  # - DSL client should verify if the url is valid and reachable
  # - if this check passes server should be reachable
  #
  #  ==== Returns
  #
  #  - boolean
  #
  def valid_url?(url)
    return false unless valid_uri_syntax? url
    Ping.pingecho URI(url).host, TIMEOUT, 80
  end

  # HTTP URL syntax validator
  #
  # Tells wheather if a url has a valid syntax. and if it is an HTTP
  # like url
  #
  # NOTE: Don't accept simple urls like: "localhost"
  # All requests must be under the HTTP
  #
  #  ==== Returns
  #
  #  - boolean
  #
  def valid_uri_syntax?(url)
    return false unless url =~ /^https?:\/\//
    begin
      URI.parse(url)
      return true
    rescue URI::InvalidURIError
      return false
    end
  end

  # Get last URL by redirection
  #
  def get_last_response_with_url(url, headers = {}, retries = 5, last_host = nil)
    raise ArgumentError, 'HTTP redirect too deep' if retries.zero?
    url = last_host.present? && !(url =~ /^https?:\/\//) ? "http://#{last_host}#{url}" : url
    url = URI.parse(url) unless url.is_a?(URI::HTTP)
    http = Net::HTTP.new( url.host || url.registry )
    http.read_timeout = TIMEOUT
    http.open_timeout = 2
    http.start do |http|
      response = http.request_get(url.request_uri, headers)
      case response
        when Net::HTTPSuccess
          {:response => response, :url => url.to_s}
        when Net::HTTPRedirection
          get_last_response_with_url(response['location'], headers, retries - 1, url.host)
        when Net::HTTPClientError
        when Net::HTTPServerError
          #puts "NetRequest::Error"
      end
    end
  end

  protected

  # Container for handling HTTP requests width different behaviours
  #
  #  ==== Returns
  #
  #  - HTTPResponse if connection to the server was successful.
  #  - SocketError, .. if something when wrong!
  #
  # TODO: Handle timeout errors.
  #
  def extract_http_response_object(url, headers, retries)
    result = get_last_response_with_url(url, headers, retries) 
    result[:response] unless result.nil?
  end

end
