module Cesium
  module Extentions
    module ActiveRecord

      def self.included base
        base.class_eval do
          @@cesium_allowed_methods = []
          extend ClassMethods
        end
      end

      def clear_cesium_pages_cache
        @pages_cache ||= Cesium::Cache::Pages.new
        @pages_cache.clear
      end

      def clear_cesium_snippets_cache
        @snippets_cache ||= Cesium::Cache::Snippets.new
        @snippets_cache.clear
      end

      def call_chain chain
        eval(chain.to_s)
      end

      module ClassMethods

        def cesium_allowed_methods *value
          @@cesium_allowed_methods = value unless value.empty?
          @@cesium_allowed_methods
        end

      end

    end
  end
end
