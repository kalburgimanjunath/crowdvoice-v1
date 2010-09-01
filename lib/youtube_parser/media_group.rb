module YoutubeParser # :nodoc:
  class MediaGroup # :nodoc:
   include SAXMachine
   elements "media:thumbnail", :as => :thumbnails, :value => :url
  end
end