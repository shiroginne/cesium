class AddLevelCacheToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :level_cache, :integer, :default => 0
  end

  def self.down
    remove_column :pages, :level_cache
  end
end
