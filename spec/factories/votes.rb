# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :vote do |f|
  f.ip_address Time.now.tv_sec
  f.rating 1
  f.association :content, :factory => :content, :url => 'http://github.com/thoughtbot/factory_girl', :type => 'Link'
end

