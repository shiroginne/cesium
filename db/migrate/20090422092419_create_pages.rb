class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :level_cache, :default => 0
      t.integer :layout_id
      t.integer :status, :limit => 1, :default => 0
      t.string :name
      t.string :path
      t.string :title
      t.text :description
      t.text :keywords

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
