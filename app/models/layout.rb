class Layout < ActiveRecord::Base
  validates_presence_of :name

  after_update :clear_cesium_pages_cache
  after_destroy :clear_cesium_pages_cache

  has_many :pages
end
