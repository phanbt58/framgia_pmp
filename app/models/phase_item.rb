class PhaseItem < ActiveRecord::Base
  belongs_to :phase
  belongs_to :item_performance
end
