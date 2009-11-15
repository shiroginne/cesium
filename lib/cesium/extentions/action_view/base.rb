module Cesium
  module Extentions
    module ActionView
      module Base

        def render_snippet name
          render :inline => Snippet.find_snippet(request.path_info, name)
        end

      end
    end
  end
end
