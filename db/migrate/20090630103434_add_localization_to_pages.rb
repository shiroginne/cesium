class AddLocalizationToPages < ActiveRecord::Migration
  def self.up
    remove_column :pages, :title
    remove_column :pages, :description
    remove_column :pages, :keywords
    create_table :page_translations do |t|
      t.string :locale
      t.integer :page_id
      t.string :title
      t.text :description
      t.text :keywords
      t.timestamps
    end
  end

  def self.down
    add_column :pages, :title, :string
    add_column :pages, :description, :text
    add_column :pages, :keywords, :text
    drop_table :page_translations
  end
end
