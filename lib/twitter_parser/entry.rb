module TwitterParser # :nodoc:
  class Entry # :nodoc:
    include SAXMachine
    element :title
    element :content, :with => { :type => "html" }
    element :author, :class => Author
  end
end