require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Cesium
  describe Cache do

    before do
      Cesium::Config.cache_path = "#{RAILS_ROOT}/tmp/cesium_test_cache"
      @cache = Cesium::Cache.new
    end

    it "cache path should be equal Cesium::Config.cache_path" do
      @cache.path.should equal Cesium::Config.cache_path
      File.should be_exists(Cesium::Config.cache_path)
    end

    it "should create cache file for page" do
      @cache.write('/contacts/hello', 'content').should == 'content'
      File.should be_exists(Cesium::Config.cache_path + '/contacts/hello/index.html.erb')
    end

    it "should read cache file for page" do
      @cache.write('/contacts/hello', 'content')
      @cache.read('/contacts/hello').should == 'content'
    end

    it "should clear cache" do
      @cache.write('/contacts/hello', 'content')
      @cache.clear
      Dir[Cesium::Config.cache_path + '/*'].should be_empty
    end

    it "should remove one file" do
      @cache.write('/contacts/hello', 'content')
      File.should be_exists(Cesium::Config.cache_path + '/contacts/hello/index.html.erb')
      @cache.remove('/contacts/hello')
      File.should_not be_exists(Cesium::Config.cache_path + '/contacts/hello/index.html.erb')
    end

    after do
      @cache.clear
    end

  end
end
