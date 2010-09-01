class AddEmailHashToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :email_hash, :string
  end

  def self.down
    remove_column :subscriptions, :email_hash
  end
end
