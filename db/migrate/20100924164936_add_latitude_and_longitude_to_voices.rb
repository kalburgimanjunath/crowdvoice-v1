class AddLatitudeAndLongitudeToVoices < ActiveRecord::Migration
  def self.up
    add_column :voices, :latitude, :decimal, :precision => 10, :scale => 7
    add_column :voices, :longitude, :decimal, :precision => 10, :scale => 7
  end

  def self.down
    remove_column :voices, :longitude
    remove_column :voices, :latitude
  end
end
