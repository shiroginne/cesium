require File.dirname(__FILE__) + "/extensions"

module Cesium
end

ActionController::Dispatcher.middleware.use Cesium::Rack::StaticOverlay, File.join(File.dirname(__FILE__), '../public')

ActionController::Base.class_eval do
  include Cesium::Extentions::ApplicationController
  include Cesium::Extentions::ActionController::Layout
end

ActiveRecord::Base.class_eval do
  include Cesium::Extentions::ActiveRecord
end

ActionView::Helpers::FormBuilder.class_eval do
  include Terbium::FormBuilder
end
