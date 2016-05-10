class ProductBacklog < ActiveRecord::Base
  belongs_to :project
  belongs_to :sprint
  
  has_many :activities
  
end
