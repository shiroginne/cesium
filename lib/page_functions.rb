# To change this template, choose Tools | Templates
# and open the template in the editor.

module PageFunctions

  def self.recent page
    Blog.find(:all, :limit => 3).map{ |b| "<li><a href=\"/blogs/#{b.id}\">#{b.title}</a></li>" }.join('')
  end
    
end
