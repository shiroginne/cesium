module Cesium
  class Config
    cattr_accessor :cache_path
    @@cache_path = "#{RAILS_ROOT}/tmp/cesium_cache"

    cattr_accessor :cache_on
    @@cache_on = true
  end
end
