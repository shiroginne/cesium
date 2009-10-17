class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
      t.string :login, :null => false
      t.string :email, :null => false
      t.string :crypted_password, :null => false
      t.string :password_salt, :null => false
      t.string :persistence_token, :null => false

      t.timestamps
    end
    Admin.new({:login => 'admin', :password => 'admin', :password_confirmation => 'admin', :email => 'admin@localhost.com'}).save!
  end

  def self.down
    drop_table :admins
  end
end
