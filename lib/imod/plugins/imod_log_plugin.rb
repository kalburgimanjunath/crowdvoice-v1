class ImodLogPlugin < ImodPlugin

  def post_initialize
    @log.info 'Post initialization'
  end

  def parse_mail(uid)
    @log.info "Fetching mail [#{uid}] (may take a while)"
  end

  def cleanup
    @log.info 'Cleaning up'
  end

end
