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
          #controllers = RAILS_ENV == 'development' ? admined_controllers_list : AdminController.subclasses
          admined_controllers_list.map! { |c| c.constantize }.reject { |c| c.menu_position == 0}.sort! { |a,b| a.menu_position <=> b.menu_position }.each do |c|
            c = c.controller_name
            block.call(c.humanize, polymorphic_path([:admin, c.classify.constantize.new]))
          end
        end

        def admined_controllers_list
          controllers_paths = $LOAD_PATH.select { |path| path.match(/\/controllers$/) }
          controllers = []
          controllers_paths.each do |path|
            Dir.glob(File.join(path, 'admin', '*_controller.rb')).each do |f|
              file = File.basename(f).gsub( /^(.+).rb/, '\1')
              controller_name = "admin/#{file}".camelize
              controllers << controller_name if controller_name.constantize.superclass.controller_name == 'admin'
            end
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
            flash[:notice] = "You must be logged in to access this page"
            redirect_to admin_login_url
            return false
          end
        end

        def require_cesium_no_admin
          if cesium_admin
            flash[:notice] = "You must be logged out to access this page"
            redirect_to '/'
            return false
          end
        end

        def store_referer
          session[:return_to] = request.referer
        end

        def redirect_stored_or default
          redirect_to(session[:return_to] || default)
          session[:return_to] = nil
        end

        def stored_path_or default
          session[:return_to] || default
        end

        def redirect_back_or path
          redirect_to :back
          rescue ActionController::RedirectBackError
          redirect_to path
        end

      end

    end
  end
end
