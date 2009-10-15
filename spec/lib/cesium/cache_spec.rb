require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
#require 'fakefs'

module Cesium
  describe Cache do

    before do
      Cesium::Config.cache_path = "#{RAILS_ROOT}/tmp/cesium_test_cache"
      @cache = Cesium::Cache.new
    end

    it "cache path should be equal Cesium::Config.cache_path" do
      @cache.path.should equal Cesium::Config.cache_path
      File.exists?(Cesium::Config.cache_path).should be true
    end

    it "should create cache file for page" do
      @cache.write('/contacts/hello', 'content').should == 'content'
      File.exists?(Cesium::Config.cache_path + '/contacts/hello.html.erb').should be true
    end

    it "should read cache file for page" do
      @cache.read('/contacts/hello').should == 'content'
    end

    it "should clear cache" do
      @cache.write('/contacts/hello', 'content')
      @cache.clear
      Dir[Cesium::Config.cache_path + '/**'].empty?.should be true
    end

    it "should remove one file" do
      @cache.write('/contacts/hello', 'content')
      @cache.remove('/contacts/hello')
      File.exists?(Cesium::Config.cache_path + '/contacts/hello.html.erb').should be false
    end

  end
end
