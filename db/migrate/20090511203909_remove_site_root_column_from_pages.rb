class RemoveSiteRootColumnFromPages < ActiveRecord::Migration
  def self.up
    remove_column :pages, :site_root
  end

  def self.down
    add_column :pages, :site_root, :boolean, :default => false
  end
end
