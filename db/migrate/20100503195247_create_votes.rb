class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.string :ip_address
      t.integer :rating
      t.belongs_to :content

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
