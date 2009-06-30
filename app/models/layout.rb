class Layout < ActiveRecord::Base
  translates :body

  default_scope :include => :globalize_translations

  validates_presence_of :name
end
