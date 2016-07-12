class ProductBacklog < ActiveRecord::Base
  belongs_to :project
  belongs_to :sprint

  has_many :activities

  delegate :name, to: :project, prefix: true
end
