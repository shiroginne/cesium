module Cesium
  module App
    module Controllers
      module AdminController

        def self.included base
          base.class_eval do
            extend ClassMethods
            class_inheritable_accessor :menu_pos
          end
        end

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

        [:index, :show, :form].each do |sym|
          define_method("#{sym}_fields") do
            self.class.terbium_fields[sym]
          end
        end

        module ClassMethods

          [:index, :show, :form].each do |sym|
            define_method(sym) do |&block|
              @terbium_option = sym
              block.call if block
            end
          end

          def menu_position value = nil
            value ? write_inheritable_attribute(:menu_pos, value) : (read_inheritable_attribute(:menu_pos) || 1000)
          end

          def field name, options = {}
            @terbium_fields = {} unless @terbium_fields
            @terbium_fields[@terbium_option] = [] unless @terbium_fields[@terbium_option]
            @terbium_fields[@terbium_option] << ::Terbium::Field.new(name, options)
          end

          def terbium_fields
            @terbium_fields
          end

        end

      end
    end
  end
end
