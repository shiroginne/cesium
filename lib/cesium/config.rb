module Cesium
  module Config
    mattr_accessor :cache_path
    @@cache_path = "#{RAILS_ROOT}/tmp/cesium_cache"

    mattr_accessor :pages_cache_path
    @@pages_cache_path = File.join(@@cache_path, 'pages')

    mattr_accessor :snippets_cache_path
    @@snippets_cache_path = File.join(@@cache_path, 'snippets')

    mattr_accessor :cache_on
    @@cache_on = true

    mattr_accessor :own_auth
    @@own_auth = false

    mattr_accessor :allow_erb
    @@allow_erb = false
  end
end
