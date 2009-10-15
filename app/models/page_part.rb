class PagePart < ActiveRecord::Base
  belongs_to :page

  validates_uniqueness_of :name, :scope => :page_id
  validates_presence_of :name

  after_update :clear_cesium_cache
  after_destroy :clear_cesium_cache
end
