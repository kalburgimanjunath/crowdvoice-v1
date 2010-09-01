# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :static_page do |f|
  f.sequence(:title) { |n| "Some title #{n}" }
  f.sequence(:content) { |n| "The famous lorem ipsum thing #{n}" }
  f.sequence(:page_type) { |n| "sometype #{n}" }
end
