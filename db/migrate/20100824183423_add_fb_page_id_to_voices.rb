class AddFbPageIdToVoices < ActiveRecord::Migration
  def self.up
    add_column :voices, :fb_page_id, :string
  end

  def self.down
    remove_column :voices, :fb_page_id
  end
end
