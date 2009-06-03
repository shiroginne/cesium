class AddNestedSetToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :lft, :integer
    add_column :pages, :rgt, :integer
    remove_column :pages, :position
    remove_column :pages, :pages_count
  end

  def self.down
    remove_column :pages, :lft
    remove_column :pages, :rgt
    add_column :pages, :position, :integer
    add_column :pages, :pages_count, :integer, :default => 0
  end
end
