module Cesium
  module Extentions
    module ApplicationController

      def self.included base
        base.class_eval do
          helper_method :cesium_admin_session, :cesium_admin
          filter_parameter_logging :password, :password_confirmation
        end
      end

      def cesium_admin_session
        @cesium_admin_session ||= AdminSession.find
      end

      def cesium_admin
        @cesium_admin ||= cesium_admin_session && cesium_admin_session.admin
      end

      def require_cesium_admin
        unless cesium_admin
          redirect_to admin_login_url
          return false
        end
      end

      def require_cesium_no_admin
        if cesium_admin
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
