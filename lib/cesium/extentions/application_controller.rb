module Cesium
  module Extentions
    module ApplicationController

      def self.included base
        base.class_eval do
          include InstanceMethods

          helper_method :cesium_admin_session, :cesium_admin, :admined_controllers
          filter_parameter_logging :password, :password_confirmation
        end
      end

      module InstanceMethods

        def admined_controllers &block
          (RAILS_ENV == 'development' ? admined_controllers_list : AdminController.subclasses).each do |c|
            block.call(c.constantize.controller_name.humanize, polymorphic_path([:admin, c.constantize.controller_name.classify.constantize.new]))
          end
        end

        def admined_controllers_list
          controllers = []
          glob = RAILS_ROOT + '/app/controllers/admin/*_controller.rb'
          Dir.glob(glob).each do |f|
            file = File.basename(f).gsub( /^(.+).rb/, '\1')
            controllers << "admin/#{file}".camelize
          end
          controllers
        end

        def cesium_admin_session
          @cesium_admin_session ||= AdminSession.find
        end

        def cesium_admin
          @cesium_admin ||= cesium_admin_session && cesium_admin_session.admin
        end

        def require_cesium_admin
          unless cesium_admin
            store_location
            flash[:notice] = "You must be logged in to access this page"
            redirect_to admin_login_url
            return false
          end
        end

        def require_cesium_no_admin
          if cesium_admin
            store_location
            flash[:notice] = "You must be logged out to access this page"
            redirect_to '/'
            return false
          end
        end

        def store_location
          session[:return_to] = request.request_uri
        end

        def redirect_back_or_default(default)
          redirect_to(session[:return_to] || default)
          session[:return_to] = nil
        end

      end
    end
  end
end