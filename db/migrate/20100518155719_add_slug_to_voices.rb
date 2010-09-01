class AddSlugToVoices < ActiveRecord::Migration
  def self.up
    add_column :voices, :slug, :string
  end

  def self.down
    remove_column :voices, :slug
  end
end
