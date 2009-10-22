require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

module Cesium
  module Cache
    describe Pages do

      before do
        Cesium::Config.pages_cache_path = "#{RAILS_ROOT}/tmp/cesium_test_cache"
        Cesium::Config.cache_on = true
        @cache = Cesium::Cache::Pages.new
      end

      it "cache path should be equal Cesium::Config.pages_cache_path" do
        @cache.path.should equal Cesium::Config.pages_cache_path
        File.should be_exists(Cesium::Config.pages_cache_path)
      end

      it "should create cache file for page" do
        @cache.write('/contacts/hello', 'content').should == 'content'
        File.should be_exists(Cesium::Config.pages_cache_path + '/contacts/hello/index.html.erb')
      end

      it "should read cache file for page" do
        @cache.write('/contacts/hello', 'content')
        @cache.read('/contacts/hello').should == 'content'
      end

      it "should clear cache" do
        @cache.write('/contacts/hello', 'content')
        @cache.clear
        Dir[Cesium::Config.pages_cache_path + '/*'].should be_empty
      end

      it "should remove one file" do
        @cache.write('/contacts/hello', 'content')
        File.should be_exists(Cesium::Config.pages_cache_path + '/contacts/hello/index.html.erb')
        @cache.remove('/contacts/hello')
        File.should_not be_exists(Cesium::Config.pages_cache_path + '/contacts/hello/index.html.erb')
      end

      after do
        @cache.clear
      end

    end
  end
end
