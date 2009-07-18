# To change this template, choose Tools | Templates
# and open the template in the editor.

class PageContext < Radius::Context

  include TagsDefinition

  attr_reader :page

  def initialize page
    super() do |c|
      define_tags c
    end
    @page = page
    globals.page = @page
  end
  
end
