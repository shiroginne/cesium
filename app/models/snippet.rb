class Snippet < ActiveRecord::Base
  validates_presence_of :name

  after_update :clear_cesium_pages_cache, :clear_cesium_snippets_cache
  after_destroy :clear_cesium_pages_cache, :clear_cesium_snippets_cache

  def self.find_snippet path, name
    @snippets_cache ||= Cesium::Cache::Snippets.new
    if @snippets_cache.exists? path, name
      logger.info("Render snippet '#{name}' for page '#{path}' from cache")
      @snippets_cache.read path, name
    else
      page = Page.find_page path
      snippet = Snippet.find_by_name name
      @snippets_cache.write path, name, page.parse(snippet.body, true)
    end
  end
end
