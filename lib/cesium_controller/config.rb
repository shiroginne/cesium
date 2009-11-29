module CesiumController
  class Config

    def self.attr_accessor_default name, default
      attr_writer name
      define_method name do
        v = instance_variable_get("@#{name}".to_sym)
        v.nil? ? default : v
      end
    end

    attr_accessor_default :position, 1000
    attr_accessor_default :condition, proc { Cesium::Config.own_auth ? true : !!cesium_admin }

  end
end
