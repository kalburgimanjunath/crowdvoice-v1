class RemovePosteadAtFromContents < ActiveRecord::Migration
  def self.up
    remove_column :contents, :posted_at
  end

  def self.down
    add_column :contents, :posted_at, :date
  end
end
