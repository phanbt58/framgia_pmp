class Sheet < ActiveRecord::Base
  has_many :cells
  has_many :headers
  has_many :triggers

  belongs_to :user
end
