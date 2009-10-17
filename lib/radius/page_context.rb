# To change this template, choose Tools | Templates
# and open the template in the editor.

module Radius
  class PageContext < Radius::Context

    include TagsDefinition

    attr_reader :page, :tag_tracker

    def initialize page
      super() do |c|
        define_tags c
      end
      @page = page
      @tag_tracker = Cesium::TagTracker.new
      globals.page = @page
      globals.tag_tracker = @tag_tracker
    end

  end
end
