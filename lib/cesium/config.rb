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

    cattr_accessor :filter_erb
    @@filter_erb = true
  end
end
