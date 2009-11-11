class Admin < ActiveRecord::Base
  acts_as_authentic

  default_scope :order => 'login'

end
