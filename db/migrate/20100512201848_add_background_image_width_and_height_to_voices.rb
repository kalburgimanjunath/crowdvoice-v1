class AddBackgroundImageWidthAndHeightToVoices < ActiveRecord::Migration
  def self.up
    add_column :voices, :background_image_width, :integer
    add_column :voices, :background_image_height, :integer
  end

  def self.down
    remove_column :voices, :background_image_width
    remove_column :voices, :background_image_height
  end
end
