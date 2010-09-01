class ContentSweeper < ActionController::Caching::Sweeper
  observe Content

  def after_save(content)
    expire_cache(content)
  end

  def after_destroy(content)
    expire_cache(content)
  end

  def expire_cache(content)
    expire_page '/contents.rss'
  end
end

