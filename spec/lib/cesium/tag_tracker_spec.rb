require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Cesium

  describe TagTracker do

    it "should parse tags properly" do
      @tracker = TagTracker.new
      text = "hello some tag <%= render %> and oher tag " + @tracker.wrap("<%= other_render %>") + @tracker.wrap("<%= third_render %>")
      result = "hello some tag &lt;%= render %&gt; and oher tag <%= other_render %><%= third_render %>"
      @tracker.parse(text).should == result
    end

  end

end
