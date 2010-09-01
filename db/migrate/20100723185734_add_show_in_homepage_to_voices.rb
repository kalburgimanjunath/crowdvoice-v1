class AddShowInHomepageToVoices < ActiveRecord::Migration
  def self.up
    add_column :voices, :show_in_homepage, :boolean
  end

  def self.down
    remove_column :voices, :show_in_homepage
  end
end
