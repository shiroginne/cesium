class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :parent_id
      t.integer :layout_id, :default => -1
      t.string :name
      t.string :path
      t.boolean :site_root, :default => false
      t.string :title
      t.text :description
      t.text :keywords
      t.integer :position
      t.integer :status, :limit => 1, :default => 0
      t.integer :create_user_id
      t.integer :update_user_id
      t.timestamp :published_at

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
