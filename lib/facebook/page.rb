module Facebook
  class Page

    def initialize(id, access_token)
      @id = id
      @access_token = access_token
      @graph = Koala::Facebook::GraphAPI.new(@access_token)
    end

    def members(limit = 500)
      begin
        @members ||= @graph.get_connections(@id, "members", :limit => limit)
      rescue Koala::Facebook::APIError
        @members = []
      end
    end
  end
end
