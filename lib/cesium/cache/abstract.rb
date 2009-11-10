module Cesium
  module Cache
    class Abstract
      attr_accessor :path

      def initialize
        @path = Cesium::Config.cache_path

        FileUtils.mkdir_p(@path)
      end

      def read path
        content = ''
        fpath = file_path(path)
        if File.exists? fpath
          File.open(fpath, "r") do |file|
            file.flock(File::LOCK_EX)
            content = file.read
            file.flock(File::LOCK_UN)
          end
        end
        content
      end

      def write path, content
        fpath = file_path(path)
        FileUtils.mkdir_p(File.dirname(fpath))
        File.open(fpath, "w+") do |file|
          file.flock(File::LOCK_EX)
          file.write(content)
          file.flock(File::LOCK_UN)
        end
        content
      end

      def remove path
        File.delete file_path(path)
      end

      def clear
        FileUtils.rm_rf Dir.glob(File.join(@path, '*'))
      end

      def exists? path
        Cesium::Config.cache_on && File.file?(file_path(path))
      end

      def file_path path
        "#{File.join(@path, path)}.html.erb"
      end

    end
  end
end
