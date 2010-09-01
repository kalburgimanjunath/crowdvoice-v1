module YoutubeParser # :nodoc:
  class Entry # :nodoc:
    include SAXMachine
    element "title"
    element "media:group", :as => :mediagroup, :class => MediaGroup
  end
end