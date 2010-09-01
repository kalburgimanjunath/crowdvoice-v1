# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :user do |f|
  f.sequence(:email)         { |n| "foo#{n}@bar.com" }
  f.password                 'secret'
  f.password_confirmation    'secret'
  f.role                     'moderator'
end
