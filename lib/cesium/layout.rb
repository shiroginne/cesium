module Cesium
  module Layout

    def self.included base
      base.class_eval do
        extend ClassMethods
      end
    end

    def cesium_layout
      @pages_cache ||= Cesium::Cache::Pages.new
      if @pages_cache.exists? self.path
        logger.info("Render cesium layout for '#{self.path}' from cache")
      else
        text = parser_init.parse(self.get_layout.body)
        text = @context.tag_tracker.parse(text)
        @pages_cache.write self.path, text
      end
      @pages_cache.file_path self.path
    end

    module ClassMethods

      def build_layout path
        path.gsub!(/\/$/, '')
        candidates = find(:all, :conditions => ['path like ?', path.scan(/^\/[\w-]*/)[0] + '%']).reverse
        for c in candidates do
          return c.cesium_layout if path =~ /^#{c.path.gsub(/\*/, '.*')}/
        end
        raise
      end

    end

  end
end
