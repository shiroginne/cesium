class AddLocalizationToPageParts < ActiveRecord::Migration
  def self.up
    remove_column :page_parts, :body
    create_table :page_part_translations do |t|
      t.string :locale
      t.integer :page_part_id
      t.text :body
      t.timestamps
    end
  end

  def self.down
    add_column :page_parts, :body, :text
    drop_table :page_part_translations
  end
end
