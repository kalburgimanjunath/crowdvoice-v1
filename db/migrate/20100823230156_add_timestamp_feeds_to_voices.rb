class AddTimestampFeedsToVoices < ActiveRecord::Migration
  def self.up
    add_column :voices, :last_rss, :datetime
    add_column :voices, :last_tweet, :datetime
  end

  def self.down
    remove_column :voices, :last_rss
    remove_column :voices, :last_tweet
  end
end
