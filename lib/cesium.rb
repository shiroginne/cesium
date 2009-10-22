require File.dirname(__FILE__) + "/extentions"
require File.dirname(__FILE__) + "/form_builder"

module Cesium
end

ActionController::Dispatcher.middleware.use Cesium::Rack::StaticOverlay, File.join(File.dirname(__FILE__), '../public')

ActionController::Base.class_eval do
  include Cesium::ApplicationController
end

ActiveRecord::Base.class_eval do
  def clear_cesium_pages_cache
    @pages_cache ||= Cesium::Cache::Pages.new
    @pages_cache.clear
  end

  def clear_cesium_snippets_cache
    @snippets_cache ||= Cesium::Cache::Snippets.new
    @snippets_cache.clear
  end
end
