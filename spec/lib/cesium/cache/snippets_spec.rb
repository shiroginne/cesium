require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

module Cesium
  module Cache
    describe Snippets do

      before do
        Cesium.config[:cache_path] = "#{RAILS_ROOT}/tmp/cesium_test_cache"
        @path = File.join(Cesium.config[:cache_path], 'snippets')
        Cesium.config[:allow_cache] = true
        @cache = Cesium::Cache::Snippets.new
      end

      it "cache path should be equal @path" do
        @cache.path.should == @path
        File.should be_exists(@path)
      end

      it "should create cache file for page" do
        @cache.write('/contacts/hello', 'navigation', 'content').should == 'content'
        File.should be_exists(@path + '/contacts/hello/navigation.html.erb')
      end

      it "should read cache file for page" do
        @cache.write('/contacts/hello', 'navigation', 'content')
        @cache.read('/contacts/hello', 'navigation').should == 'content'
      end

      it "should clear cache" do
        @cache.write('/contacts/hello', 'navigation', 'content')
        @cache.clear
        Dir[@path + '/*'].should be_empty
      end

      it "should remove one file" do
        @cache.write('/contacts/hello', 'navigation', 'content')
        File.should be_exists(@path + '/contacts/hello/navigation.html.erb')
        @cache.remove('/contacts/hello', 'navigation')
        File.should_not be_exists(@path + '/contacts/hello/navigation.html.erb')
      end

      after do
        @cache.clear
      end

    end
  end
end
