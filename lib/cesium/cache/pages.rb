module Cesium
  module Cache
    class Pages < Cesium::Cache::Abstract

      def initialize
        @path = Cesium::Config.pages_cache_path

        FileUtils.mkdir_p(@path)
      end

      protected

      def file_path path
        File.join(@path, path, 'index.html.erb')
      end

    end
  end
end