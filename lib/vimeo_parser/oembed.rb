module VimeoParser
  class Oembed
    include SAXMachine
    element :thumbnail_url, :as => :thumbnail
    element :thumbnail_width, :as => :width
    element :thumbnail_height, :as => :height
  end
end