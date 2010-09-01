class StaticPage < ActiveRecord::Base
  validates :title, :presence => true
  validates :content, :presence => true
  validates :page_type, :presence => true, :uniqueness => true
end
