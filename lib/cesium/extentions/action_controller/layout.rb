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
            path, last_mtime = ::Page.cesium_layout_path(request.path_info)
            template = ::ActionView::ReloadableTemplate.new(path)
            template.previously_last_modified = last_mtime
            template.reset_cache_if_stale!
          else
            orig_find_layout(layout, format, html_fallback)
          end
        end

      end
    end
  end
end
