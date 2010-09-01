class AddKeywordsToVoices < ActiveRecord::Migration
  def self.up
    add_column :voices, :keywords, :text
  end

  def self.down
    remove_column :voices, :keywords
  end
end
