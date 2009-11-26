module CesiumController
  module Mutate

    module SingletoneMethods

      def mutate_to_cesuim_admin_controller
        before_filter :require_cesium_admin, :process_filters
        layout 'cesium_admin'
        class_inheritable_accessor :menu_pos
        include InstanceMethods
        extend ClassMethods
      end

      def cesium_admin?
        false
      end

    end

    module InstanceMethods

      def helpers
        @helpers ||= "Admin::#{controller_class_name}".constantize.helpers
      end

      def model
        @model ||= controller_name.classify.constantize
      end

      def model_name
        @model_name ||= controller_name.singularize
      end

      def render_action action
        result = "admin_views/#{action}.html.erb"
        view_paths.each do |path|
          result = File.join('admin', controller_name, "#{action}.html.erb") if File.exists?(File.join(path, 'admin', controller_name, "#{action}.html.erb"))
        end
        render result
      end

      def process_filters
        session[:filters] = {} unless session.key?(:filters)
        session[:filters][model_name.to_sym] = {} unless session[:filters].key?(model_name.to_sym)
        if params[:order] && field_exists?(params[:order])
          case session[:filters][model_name.to_sym][:order]
          when params[:order] then
            session[:filters][model_name.to_sym][:order] = "#{params[:order]} DESC"
          when "#{params[:order]} DESC" then
            session[:filters][model_name.to_sym].delete(:order)
          else
            session[:filters][model_name.to_sym][:order] = params[:order]
          end
        end
        redirect_to request.referer if params[:order] || params[:conditions]
      end

    end

    module ClassMethods

      def menu_position value = nil
        value ? write_inheritable_attribute(:menu_pos, value) : (read_inheritable_attribute(:menu_pos) || 1000)
      end

      def cesium_admin?
        true
      end

    end

  end
end
