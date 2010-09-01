class CreateVoices < ActiveRecord::Migration
  def self.up
    create_table :voices do |t|
      t.string :title, :null => false
      t.text :about
      t.string :location
      t.belongs_to :user
      t.boolean :allow_posting
      t.date :expired_at
      t.string :twitter_search
      
      t.string :background_image_file_name
      t.string :background_image_content_type
      t.integer :background_image_file_size
      t.datetime :background_image_updated_at
      
      t.string :header_background_image_file_name
      t.string :header_background_image_content_type
      t.integer :header_background_image_file_size
      t.datetime :header_background_image_updated_at
            
      t.timestamps
    end
    
    add_index :voices, :user_id
    add_index :voices, :title
  end

  def self.down
    drop_table :voices
  end
end
