class ReprocessImageAttachmentsForVoice < ActiveRecord::Migration
  def self.up
    Voice.all.each { |voice| voice.background_image.reprocess! rescue true }
  end

  def self.down
  end
end
