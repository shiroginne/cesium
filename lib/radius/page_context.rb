require File.join(File.dirname(__FILE__), 'error.rb')

module Radius
  class PageContext < Radius::Context

    include TagsDefinition

    attr_reader :page, :tag_tracker

    def initialize page
      super() do |c|
        define_tags c
      end
      globals.page = @page = page
      globals.tag_tracker = @tag_tracker = Cesium::TagTracker.new
      globals.where = {:type => 'page', :name => "#{page.title}"}
    end

  end
end
