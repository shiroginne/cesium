require "#{File.dirname(__FILE__)}/../lib/cesium/config"
require "#{File.dirname(__FILE__)}/../lib/cesium/cache"

namespace :cesium do
  desc "Sync extra files from cesium plugin."
  task :sync do
    system "rsync -ruv vendor/plugins/cesium/db/migrate db"
  end

  desc "Clears cesium cache"
  task :cache_clear do
    Cesium::Cache.new.clear
  end
end
