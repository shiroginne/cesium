class CesiumLayoutError < StandardError
end

module Cesium
  module Layout

    def self.included base
      base.class_eval do
        extend ClassMethods
      end
    end

    def cesium_layout_path
      @pages_cache ||= Cesium::Cache::Pages.new
      last_mtime = @pages_cache.mtime(self.path) if File.exists?(@pages_cache.file_path(self.path))
      if @pages_cache.exists? self.path
        logger.info("Render cesium layout for '#{self.path}' from cache")
      else
        text = parser_init.parse(self.get_layout.body)
        text = @context.tag_tracker.parse(text)
        @pages_cache.write self.path, text
      end
      return @pages_cache.file_path(self.path), last_mtime
    end

    module ClassMethods

      def cesium_layout_path path
        path.gsub!(/\/$/, '')
        candidates = find(:all, :conditions => ['path like ?', path.scan(/^\/[\w-]*/)[0] + '%']).reverse
        for c in candidates do
          return c.cesium_layout_path if path =~ /^#{c.path.gsub(/\*/, '.*')}/
        end
        raise CesiumLayoutError.new("Can`t find cesium layout for #{path}")
      end

    end

  end
end
