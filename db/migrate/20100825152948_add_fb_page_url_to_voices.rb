class AddFbPageUrlToVoices < ActiveRecord::Migration
  def self.up
    rename_column :voices, :fb_page_id, :fb_page_url
  end

  def self.down
    rename_column :voices, :fb_page_url, :fb_page_id
  end
end
