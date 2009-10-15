begin
  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
  Factories.factory(File.dirname(__FILE__) + "/factories/*.rb")
rescue LoadError
  puts "You need to install rspec in your base app"
  exit
end

plugin_spec_dir = File.dirname(__FILE__)
ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

