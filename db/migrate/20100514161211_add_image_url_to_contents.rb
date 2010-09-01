class AddImageUrlToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :image_url, :string
  end

  def self.down
    remove_column :contents, :image_url
  end
end
