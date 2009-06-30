class AddLocalizationToLayouts < ActiveRecord::Migration
  def self.up
    remove_column :layouts, :body
    create_table :layout_translations do |t|
      t.text :body

      t.timestamps
    end
  end

  def self.down
    add_column :layouts, :body, :text
    drop_table :layout_translations
  end
end
