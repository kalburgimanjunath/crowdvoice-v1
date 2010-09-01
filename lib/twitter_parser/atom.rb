module TwitterParser # :nodoc:
  class Atom # :nodoc:
    include SAXMachine
    elements :entry, :as => :entries, :class => Entry
  end
end