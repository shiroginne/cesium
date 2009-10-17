require File.dirname(__FILE__) + "/cesium/application_controller"
require File.dirname(__FILE__) + "/cesium/config"
require File.dirname(__FILE__) + "/cesium/cache"
require File.dirname(__FILE__) + "/cesium/tag_tracker"
require File.dirname(__FILE__) + "/cesium/rack/static_overlay"
require File.dirname(__FILE__) + "/extentions"
require File.dirname(__FILE__) + "/form_builder"

ActionController::Dispatcher.middleware.use Cesium::Rack::StaticOverlay, File.join(File.dirname(__FILE__), '../public')

ActionController::Base.class_eval do
  include Cesium::ApplicationController
end

ActiveRecord::Base.class_eval do
  def clear_cesium_cache
    @cache ||= Cesium::Cache.new
    @cache.clear
  end
end
