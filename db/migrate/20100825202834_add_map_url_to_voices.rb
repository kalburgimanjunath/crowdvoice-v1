class AddMapUrlToVoices < ActiveRecord::Migration
  def self.up
    add_column :voices, :map_url, :string
  end

  def self.down
    remove_column :voices, :map_url
  end
end
