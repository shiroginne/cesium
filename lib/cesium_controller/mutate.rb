module CesiumController
  module Mutate

    def self.included base
      base.class_eval do
        class_inheritable_accessor :cesium_config
        self.cesium_config = CesiumController::Config.new
        extend SingletoneMethods
      end
    end

    module SingletoneMethods

      def cesium_admin_controller &block

        block.call self.cesium_config if block

        before_filter :require_cesium_admin unless Cesium::Config.own_auth
        before_filter :process_filters

        layout 'cesium'

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
        result = "cesium/#{action}.html.erb"
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

      def cesium_admin?
        true
      end

    end

  end
end
