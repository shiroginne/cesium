module Cesium
  module Cache
    class Snippets < Cesium::Cache::Abstract

      def initialize
        @path = File.join(Cesium.config[:cache_path], 'snippets')

        FileUtils.mkdir_p(@path)
      end

      def read path, name
        super(File.join(path, name))
      end

      def write path, name, content
        super(File.join(path, name), content)
      end

      def remove path, name
        super(File.join(path, name))
      end

      def exists? path, name
        super(File.join(path, name))
      end

    end
  end
end
