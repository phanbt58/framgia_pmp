class Activity < ActiveRecord::Base
  belongs_to :product_backlog
  
  has_many :work_performace_datas
end
