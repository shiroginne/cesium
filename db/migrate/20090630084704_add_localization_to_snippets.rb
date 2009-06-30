class AddLocalizationToSnippets < ActiveRecord::Migration
  def self.up
    remove_column :snippets, :body
    create_table :snippet_translations do |t|
      t.string :locale
      t.integer :snippet_id
      t.text :body
      t.timestamps
    end
  end

  def self.down
    add_column :snippet, :body, :text
    drop_table :snippet_translations
  end
end
