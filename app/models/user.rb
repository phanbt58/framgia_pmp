class User < ActiveRecord::Base
  has_many :assignees
  has_many :time_logs
  has_many :activities
  has_many :projects

  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable

  enum role: [:member, :leader, :manager]

  validates :name, presence: true, length: {maximum: 50}
end
