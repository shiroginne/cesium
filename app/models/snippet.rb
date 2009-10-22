class Snippet < ActiveRecord::Base
  validates_presence_of :name

  after_update :clear_cesium_pages_cache, :clear_cesium_snippets_cache
  after_destroy :clear_cesium_pages_cache, :clear_cesium_snippets_cache
end
