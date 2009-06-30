class Snippet < ActiveRecord::Base
  translates :body
  validates_presence_of :name
end
