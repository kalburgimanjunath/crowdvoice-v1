class AddPaperclipToContent < ActiveRecord::Migration

  def self.up
    add_column :contents, :mailed_attachment_file_name, :string
    add_column :contents, :mailed_attachment_content_type, :string
    add_column :contents, :mailed_attachment_file_size, :integer
    add_column :contents, :mailed_attachment_updated_at, :string

    add_column :contents, :width, :integer
    add_column :contents, :height, :integer
  end

  def self.down
    remove_column :contents, :mailed_attachment_file_name
    remove_column :contents, :mailed_attachment_content_type
    remove_column :contents, :mailed_attachment_file_size
    remove_column :contents, :mailed_attachment_updated_at

    remove_column :contents, :width
    remove_column :contents, :height
  end

end
