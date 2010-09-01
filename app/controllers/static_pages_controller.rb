class StaticPagesController < ApplicationController
  layout "admin"
  caches_page :sitemap

  def about
  end
  
  def sitemap
    @voices = Voice.all
  end
end
