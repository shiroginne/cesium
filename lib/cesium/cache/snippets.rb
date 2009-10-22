module Cesium
  module Cache
    class Snippets < Cesium::Cache::Abstract

      def initialize
        @path = Cesium::Config.snippets_cache_path

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
