class Announcement < ActiveRecord::Base
  belongs_to :voice

  validates :title, :presence => true
  validates :content, :presence => true
  validates :voice_id, :presence => true

end
