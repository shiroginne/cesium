require File.dirname(__FILE__) + "/extensions"

module Cesium
end

ActionController::Dispatcher.middleware.use Cesium::Rack::StaticOverlay, File.join(File.dirname(__FILE__), '../public')

ActionController::Base.class_eval do
  include Cesium::Extensions::ActionController::Base
  include Cesium::Extensions::ActionController::Layout
  extend CesiumController::Mutate::SingletoneMethods
end

ActiveRecord::Base.class_eval do
  include Cesium::Extensions::ActiveRecord::Base
end

ActionView::Base.class_eval do
  include Cesium::Extensions::ActionView::Base
end

ActionView::Helpers::FormBuilder.class_eval do
  include Terbium::FormBuilder
end
