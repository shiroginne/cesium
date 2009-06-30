class PagePart < ActiveRecord::Base
  translates :body

  belongs_to :page

  validates_uniqueness_of :name, :scope => :page_id
  validates_presence_of :name
end
