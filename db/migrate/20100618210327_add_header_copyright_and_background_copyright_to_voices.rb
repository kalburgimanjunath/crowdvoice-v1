class AddHeaderCopyrightAndBackgroundCopyrightToVoices < ActiveRecord::Migration
  def self.up
    add_column :voices, :header_copyright, :string
    add_column :voices, :background_copyright, :string
  end

  def self.down
    remove_column :voices, :background_copyright
    remove_column :voices, :header_copyright
  end
end
