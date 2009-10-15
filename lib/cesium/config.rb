module Cesium
  class Config
    cattr_accessor :cache_path

    @@cache_path = "#{RAILS_ROOT}/tmp/cesium_cache"
  end
end
