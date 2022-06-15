class Agent < ApplicationRecord
  has_and_belongs_to_many :polls, dependent: :destroy

  has_secure_password :validations => false
  validates :name, presence: true
  validates :email, presence: true

  has_many :onboardings
  has_many :voters, through: :onboardings


  def type
    "Agent"
  end
end