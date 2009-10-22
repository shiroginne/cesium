require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

module Cesium
  module Cache
    describe Snippets do

      before do
        Cesium::Config.snippets_cache_path = "#{RAILS_ROOT}/tmp/cesium_test_cache"
        Cesium::Config.cache_on = true
        @cache = Cesium::Cache::Snippets.new
      end

      it "cache path should be equal Cesium::Config.snippets_cache_path" do
        @cache.path.should equal Cesium::Config.snippets_cache_path
        File.should be_exists(Cesium::Config.snippets_cache_path)
      end

      it "should create cache file for page" do
        @cache.write('/contacts/hello', 'navigation', 'content').should == 'content'
        File.should be_exists(Cesium::Config.snippets_cache_path + '/contacts/hello/navigation.html.erb')
      end

      it "should read cache file for page" do
        @cache.write('/contacts/hello', 'navigation', 'content')
        @cache.read('/contacts/hello', 'navigation').should == 'content'
      end

      it "should clear cache" do
        @cache.write('/contacts/hello', 'navigation', 'content')
        @cache.clear
        Dir[Cesium::Config.snippets_cache_path + '/*'].should be_empty
      end

      it "should remove one file" do
        @cache.write('/contacts/hello', 'navigation', 'content')
        File.should be_exists(Cesium::Config.snippets_cache_path + '/contacts/hello/navigation.html.erb')
        @cache.remove('/contacts/hello', 'navigation')
        File.should_not be_exists(Cesium::Config.snippets_cache_path + '/contacts/hello/navigation.html.erb')
      end

      after do
        @cache.clear
      end

    end
  end
end
