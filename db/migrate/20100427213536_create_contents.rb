class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      # generic
      t.string :type,                  :null => false

      # Allow nil urls, for downloaded mail attachments.
      t.string :url #,                 :null => false

      t.date :posted_at
      t.integer :positive_votes_count, :default => 0
      t.integer :negative_votes_count, :default => 0
      t.integer :overall_score,        :default => 0
      t.boolean :approved,             :default => false
      t.datetime :approved_at
      t.string :thumbnail_url
      t.belongs_to :voice

      # image
      t.string :emailed_from
      t.text :description

      # link
      t.string :page_title
      t.string :page_content

      t.timestamps
    end

    add_index :contents, :type
    add_index :contents, :voice_id
    add_index :contents, :approved
  end

  def self.down
    drop_table :contents
  end
end
