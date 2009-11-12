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
      globals.page = @page = page
      globals.tag_tracker = @tag_tracker = Cesium::TagTracker.new
    end

  end
end
