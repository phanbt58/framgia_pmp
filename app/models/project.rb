class Project < ActiveRecord::Base
  belongs_to :manager, class_name: User.name
  
  has_many :sprints
  has_many :product_backlogs
end
