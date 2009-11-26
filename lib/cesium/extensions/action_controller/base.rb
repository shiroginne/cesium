module Cesium
  module Extensions
    module ActionController
      module Base

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
            redirect_to admin_root_url
            return false
          end
        end

      end
    end
  end
end
