module Cesium
  module Cache
    class Pages < Cesium::Cache::Abstract

      def initialize
        @path = File.join(Cesium.config[:cache_path], 'pages')

        FileUtils.mkdir_p(@path)
      end

      def file_path path
        File.join(@path, path.gsub(/\*/, '.any'), 'index.html.erb')
      end

    end
  end
end
