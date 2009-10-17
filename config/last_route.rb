ActionController::Routing::Routes.draw do |map|
  map.cesium '*url', :controller => 'pages', :action => 'show'
end
