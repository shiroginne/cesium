class PagePart < ActiveRecord::Base
  belongs_to :page

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :page_id

  after_update :clear_cesium_pages_cache
  after_destroy :clear_cesium_pages_cache

  def additional= (value)
    @additional = value
  end

  def additional?
    @additional || false
  end
end
