require File.join(File.dirname(__FILE__), '/lib/extensions')
require File.join(File.dirname(__FILE__), '/lib/cesium')

ActionController::Dispatcher.middleware.use Cesium::Rack::StaticOverlay, File.join(File.dirname(__FILE__), 'public')

ActionController::Base.class_eval do
  include Cesium::Extensions::ActionController::Base
  include Cesium::Extensions::ActionController::Layout
  include CesiumController::Mutate
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
