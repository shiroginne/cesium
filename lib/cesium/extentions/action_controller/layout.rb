module Cesium
  module Extentions
    module ActionController
      module Layout

        def self.included base
          p base.respond_to? :find_layout
          base.class_eval do
            alias_method :orig_find_layout, :find_layout
            extend ClassMethods
          end
        end

        module ClassMethods

          def find_layout(layout, format, html_fallback=false)
            #if layout == "cesium_layout"
              p layout
            #else
              orig_find_layout(layout, format, html_fallback)
            #end
          end

        end

      end
    end
  end
end
