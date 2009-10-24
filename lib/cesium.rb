require File.dirname(__FILE__) + "/extentions"
require File.dirname(__FILE__) + "/form_builder"

module Cesium
end

ActionController::Dispatcher.middleware.use Cesium::Rack::StaticOverlay, File.join(File.dirname(__FILE__), '../public')

ActionController::Base.class_eval do
  include Cesium::Extentions::ApplicationController
end

ActiveRecord::Base.class_eval do
  include Cesium::Extentions::ActiveRecord
end
