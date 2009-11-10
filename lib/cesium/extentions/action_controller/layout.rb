module Cesium
  module Extentions
    module ActionController
      module Layout

        def self.append_features base
          base.instance_eval do
            alias_method :orig_find_layout, :find_layout
          end
          super
        end

      private

        def find_layout(layout, format, html_fallback=false)
          if layout == "cesium_layout"
            ::ActionView::Template.new(::Page.build_layout(request.path_info))
          else
            orig_find_layout(layout, format, html_fallback)
          end
        end

      end
    end
  end
end
