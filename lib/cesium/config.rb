module Cesium
  class Config
    cattr_accessor :cache_path
    @@cache_path = "#{RAILS_ROOT}/tmp/cesium_cache"

    cattr_accessor :pages_cache_path
    @@pages_cache_path = File.join(@@cache_path, 'pages')

    cattr_accessor :snippets_cache_path
    @@snippets_cache_path = File.join(@@cache_path, 'snippets')

    cattr_accessor :cache_on
    @@cache_on = true

    def self.filter_erb= value
      raise "Cesium::Config.filter_erb is deprecated. Please use allow_erb instead."
    end

    cattr_accessor :allow_erb
    @@allow_erb = false
  end
end
