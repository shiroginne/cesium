module Cesium
  class Cache
    attr_accessor :path

    def initialize
      @path = Cesium::Config.cache_path

      FileUtils.mkdir_p(@path)
    end

    def read path
      content = ''
      if exists? path
        File.open(file_path(path), "r") do |file|
          file.flock(File::LOCK_EX)
          content = file.read
          file.flock(File::LOCK_UN)
        end
      end
      content
    end

    def write path, content
      FileUtils.mkdir_p(File.dirname(file_path(path)))
      File.open(file_path(path), "w+") do |file|
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
      FileUtils.rm_r Dir.glob(File.join(@path, '*'))
    end

    def exists? path
      File.file? file_path(path)
    end

    private

    def file_path path
      File.join(@path, path, 'index.html.erb')
    end

  end
end
