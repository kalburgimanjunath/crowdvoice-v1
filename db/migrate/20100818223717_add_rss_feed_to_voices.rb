class AddRssFeedToVoices < ActiveRecord::Migration
  def self.up
    add_column :voices, :rss_feed, :string
  end

  def self.down
    remove_column :voices, :rss_feed
  end
end
