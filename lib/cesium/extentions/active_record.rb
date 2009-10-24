module Cesium
  module Extentions
    module ActiveRecord

      def clear_cesium_pages_cache
        @pages_cache ||= Cesium::Cache::Pages.new
        @pages_cache.clear
      end

      def clear_cesium_snippets_cache
        @snippets_cache ||= Cesium::Cache::Snippets.new
        @snippets_cache.clear
      end

    end
  end
end
