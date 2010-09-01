# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :content do |f|
  f.voice { |v| v.association(:voice) }
end

Factory.define :video do |f|
  f.voice { |v| v.association(:voice) }
  f.sequence(:url) { |n| "http://www.youtube.com/watch?v=ginTCwWfGNY&n=#{n}" }
end

Factory.define :vimeo, :parent => :video do |f|
  f.sequence(:url) { |n| "http://vimeo.com/11229946&n=#{n}" }
end

Factory.define :youtube, :parent => :video do |f|
  f.sequence(:url) { |n| "http://www.youtube.com/watch?v=ginTCwWfGNY&n=#{n}" }
end

Factory.define :image do |f|
  f.voice { |v| v.association(:voice) }
  f.sequence(:url) { |n| 
    "http://farm5.static.flickr.com/4049/4547496837_8ae7d82093_b.jpg?n=#{n}"
  }
  f.description "lorem ipsum"
end

Factory.define :link do |f|
  f.voice { |v| v.association(:voice) }
  f.sequence(:url) { |n| "http://freshout.us/?n=#{n}" }
end
