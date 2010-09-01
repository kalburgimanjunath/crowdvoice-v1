class AddColorToVoices < ActiveRecord::Migration
  def self.up
    add_column :voices, :color, :string
  end

  def self.down
    remove_column :voices, :color
  end
end
