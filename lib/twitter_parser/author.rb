module TwitterParser # :nodoc:
  class Author # :nodoc:
    include SAXMachine
    element :name
    element :uri
  end
end