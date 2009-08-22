require File.dirname(__FILE__) + "/cesium/application_controller"
require File.dirname(__FILE__) + "/extentions"
require File.dirname(__FILE__) + "/form_builder"
require File.dirname(__FILE__) + "/object"

ActionController::Base.class_eval do
  include Cesium::ApplicationController
end
