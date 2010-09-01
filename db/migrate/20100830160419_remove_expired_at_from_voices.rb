class RemoveExpiredAtFromVoices < ActiveRecord::Migration
  def self.up
    remove_column :voices, :expired_at
  end

  def self.down
    add_column :voices, :expired_at, :datetime
  end
end
