class CreateStaticPages < ActiveRecord::Migration
  def self.up
    create_table :static_pages do |t|
      t.string :title
      t.text :content
      t.string :page_type
      
      t.timestamps
    end
  end

  def self.down
    drop_table :static_pages
  end
end
