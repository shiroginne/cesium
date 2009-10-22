require "#{File.dirname(__FILE__)}/../lib/cesium/config"
require "#{File.dirname(__FILE__)}/../lib/cesium/cache/abstract"
require "#{File.dirname(__FILE__)}/../lib/cesium/cache/pages"
require "#{File.dirname(__FILE__)}/../lib/cesium/cache/snippets"

namespace :cesium do
  desc "Sync extra files from cesium plugin."
  task :sync do
    system "rsync -ruv vendor/plugins/cesium/db/migrate db"
  end

  desc "Clears cesium cache"
  task :cache_clear do
    Cesium::Cache::Pages.new.clear
    Cesium::Cache::Snippets.new.clear
  end
end
