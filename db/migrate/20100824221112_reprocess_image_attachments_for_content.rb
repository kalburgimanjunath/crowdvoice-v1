class ReprocessImageAttachmentsForContent < ActiveRecord::Migration
  def self.up
    Content.all.each { |content| content.preview.reprocess! rescue true }
  end

  def self.down
  end
end
