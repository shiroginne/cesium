namespace :cesium do
  desc "Sync extra files from cesium plugin."
  task :sync do
    system "rsync -ruv vendor/plugins/cesium/db/migrate db"
    system "rsync -ruv vendor/plugins/cesium/public ."
  end
end
