# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :voice do |f|
  f.sequence(:title) { |n| "Lorem Ipsum #{n}" }
  f.about "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
  f.location "Guadalajara, Mexico"
  f.user { |u| u.association(:user) }
  f.allow_posting true
  # FIXME: Get Rails.root in a fashioner way
  f.background_image File.new(File.dirname(__FILE__) + '/../factories/images/voice-bg.jpg')
  f.header_background_image File.new(File.dirname(__FILE__) + '/../factories/images/IranElection-WikimediaCommons.jpg')
  f.color "green"
end
