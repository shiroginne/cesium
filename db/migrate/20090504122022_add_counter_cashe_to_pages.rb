class AddCounterCasheToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :pages_count, :integer, :default => 0
  end

  def self.down
    remove_column :pages, :pages_count
  end
end
