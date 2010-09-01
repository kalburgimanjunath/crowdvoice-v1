class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email,                :null => false
      t.string :crypted_password,     :null => false
      t.string :password_salt,        :null => false
      t.string :persistence_token,    :null => false
      t.string :single_access_token,  :null => false
      t.string :role,                 :null => false
      t.string :name
      t.timestamps
    end
    
    add_index :users, :persistence_token
    add_index :users, :single_access_token
  end

  def self.down
    drop_table :users
  end
end
